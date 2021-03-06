package xt3d.gl.shaders;

import xt3d.utils.errors.XTException;
import xt3d.gl.shaders.ShaderTypedefs;
import xt3d.utils.string.StringFunctions;
import xt3d.utils.XT;

class ShaderUtils {

	public static function cloneShaderInfo(shaderInfo:ShaderInfo):ShaderInfo {
		var clone:ShaderInfo = {
			vertexProgram: shaderInfo.vertexProgram,
			fragmentProgram: shaderInfo.fragmentProgram,
			vertexDefines: shaderInfo.vertexDefines != null ? shaderInfo.vertexDefines.slice(0) : [],
			fragmentDefines: shaderInfo.fragmentDefines != null ? shaderInfo.fragmentDefines.slice(0) : [],
			vertexIncludes: shaderInfo.vertexIncludes != null ? shaderInfo.vertexIncludes.slice(0) : [],
			fragmentIncludes: shaderInfo.fragmentIncludes != null ? shaderInfo.fragmentIncludes.slice(0) : [],
			commonUniformGroups: shaderInfo.commonUniformGroups != null ? shaderInfo.commonUniformGroups.slice(0) : []
		};

		if (shaderInfo.uniforms != null) {
			clone.uniforms = new Map<String, UniformInfo>();
			for (uniformName in shaderInfo.uniforms.keys()) {
				clone.uniforms.set(uniformName, cloneUniformInfo(shaderInfo.uniforms.get(uniformName)));
			}
		}

		if (shaderInfo.types != null) {
			clone.types = new Map<String, Array<BaseTypeInfo>>();
			for (typeName in shaderInfo.types.keys()) {
				var clonedTypeDefinition = new Array<BaseTypeInfo>();
				clone.types.set(typeName, clonedTypeDefinition);

				var typeDefinition = shaderInfo.types.get(typeName);
				for (baseType in typeDefinition) {
					clonedTypeDefinition.push(cloneBaseTypeInfo(baseType));
				}
			}
		}

		if (shaderInfo.variables != null) {
			clone.variables = new Array<ShaderVariable>();
			for (shaderVariable in shaderInfo.variables) {
				clone.variables.push(cloneShaderVariable(shaderVariable));
			}
		}

		if (shaderInfo.attributes != null) {
			clone.attributes = new Map<String, AttributeInfo>();

			for (attributeName in shaderInfo.attributes.keys()) {
				clone.attributes.set(attributeName, cloneAttributeInfo(shaderInfo.attributes.get(attributeName)));
			}
		}

		return clone;
	}


	public static function cloneUniformInfo(uniformInfo:UniformInfo):UniformInfo {
		var clone:UniformInfo = {
			name: uniformInfo.name,
			type: uniformInfo.type,
			shader: uniformInfo.shader,
			defaultValue: uniformInfo.defaultValue,
			global: uniformInfo.global,
			slot: uniformInfo.slot
		};
		return clone;
	}

	public static function cloneAttributeInfo(attributeInfo:AttributeInfo):AttributeInfo {
		var clone:AttributeInfo = {
			name: attributeInfo.name,
			type: attributeInfo.type
		};
		return clone;
	}

	public static function cloneBaseTypeInfo(baseTypeInfo:BaseTypeInfo):BaseTypeInfo {
		var clone:BaseTypeInfo = {
			name: baseTypeInfo.name,
			type: baseTypeInfo.type,
			defaultValue: baseTypeInfo.defaultValue
		};
		return clone;
	}

	public static function cloneShaderVariable(shaderVariable:ShaderVariable):ShaderVariable {
		var clone:ShaderVariable = {
			name: shaderVariable.name,
			value: shaderVariable.value
		};
		return clone;
	}

	public static function extendShaderInfo(shaderInfo:ShaderInfo, shaderExtensionInfo:ShaderExtensionInfo, shaderName:String, extensionName:String) {
		if (shaderExtensionInfo.variables != null) {
			if (shaderInfo.variables == null) {
				shaderInfo.variables = new Array<ShaderVariable>();
			}

			for (shaderVariable in shaderExtensionInfo.variables) {
				var variableName = shaderVariable.name;

				var existsAlready:Bool = false;
				for (existingVariables in shaderInfo.variables) {
					if (existingVariables.name == variableName) {
						existsAlready = true;
					}
				}

				if (!existsAlready) {
					shaderInfo.variables.push(shaderVariable);

				} else {
					XT.Warn("Duplicate shader variable \"" + variableName + "\" for shader \"" + shaderName + "\" with extension \"" + extensionName + "\"");
				}
			}
		}

		if (shaderExtensionInfo.types != null) {
			if (shaderInfo.types == null) {
				shaderInfo.types = new Map<String, Array<BaseTypeInfo>>();
			}

			for (typeName in shaderExtensionInfo.types.keys()) {
				if (!shaderInfo.types.exists(typeName)) {
					var typeDefinition = shaderExtensionInfo.types.get(typeName);

					var clonedTypeDef = new Array<BaseTypeInfo>();
					shaderInfo.types.set(typeName, clonedTypeDef);

					for (baseType in typeDefinition) {
						clonedTypeDef.push(cloneBaseTypeInfo(baseType));
					}
				} else {
					XT.Warn("Duplicate shader type \"" + typeName + "\" for shader \"" + shaderName + "\" with extension \"" + extensionName + "\"");
				}
			}
		}

		if (shaderExtensionInfo.vertexDefines != null) {
			if (shaderInfo.vertexDefines == null) {
				shaderInfo.vertexDefines = new Array<String>();
			}

			for (vertexDefine in shaderExtensionInfo.vertexDefines) {
				if (shaderInfo.vertexDefines.indexOf(vertexDefine) == -1) {
					shaderInfo.vertexDefines.push(vertexDefine);
				} else {
					XT.Warn("Duplicate vertex define \"" + vertexDefine + "\" for shader \"" + shaderName + "\" with extension \"" + extensionName + "\"");
				}
			}
		}

		if (shaderExtensionInfo.fragmentDefines != null) {
			if (shaderInfo.fragmentDefines == null) {
				shaderInfo.fragmentDefines = new Array<String>();
			}

			for (fragmentDefine in shaderExtensionInfo.fragmentDefines) {
				if (shaderInfo.fragmentDefines.indexOf(fragmentDefine) == -1) {
					shaderInfo.fragmentDefines.push(fragmentDefine);
				} else {
					XT.Warn("Duplicate fragment define \"" + fragmentDefine + "\" for shader \"" + shaderName + "\" with extension \"" + extensionName + "\"");
				}
			}
		}

		if (shaderExtensionInfo.vertexIncludes != null) {
			if (shaderInfo.vertexIncludes == null) {
				shaderInfo.vertexIncludes = new Array<String>();
			}

			for (vertexInclude in shaderExtensionInfo.vertexIncludes) {
				if (shaderInfo.vertexIncludes.indexOf(vertexInclude) == -1) {
					shaderInfo.vertexIncludes.push(vertexInclude);
				} else {
					XT.Warn("Duplicate vertex include \"" + vertexInclude + "\" for shader \"" + shaderName + "\" with extension \"" + extensionName + "\"");
				}
			}
		}

		if (shaderExtensionInfo.fragmentIncludes != null) {
			if (shaderInfo.fragmentIncludes == null) {
				shaderInfo.fragmentIncludes = new Array<String>();
			}

			for (fragmentInclude in shaderExtensionInfo.fragmentIncludes) {
				if (shaderInfo.fragmentIncludes.indexOf(fragmentInclude) == -1) {
					shaderInfo.fragmentIncludes.push(fragmentInclude);
				} else {
					XT.Warn("Duplicate fragment include \"" + fragmentInclude + "\" for shader \"" + shaderName + "\" with extension \"" + extensionName + "\"");
				}
			}
		}

		if (shaderExtensionInfo.commonUniformGroups != null) {
			if (shaderInfo.commonUniformGroups == null) {
				shaderInfo.commonUniformGroups = new Array<String>();
			}

			for (commonUniformGroup in shaderExtensionInfo.commonUniformGroups) {
				if (shaderInfo.commonUniformGroups.indexOf(commonUniformGroup) == -1) {
					shaderInfo.commonUniformGroups.push(commonUniformGroup);
				}
			}
		}

		if (shaderExtensionInfo.uniforms != null) {
			if (shaderInfo.uniforms == null) {
				shaderInfo.uniforms = new Map<String, UniformInfo>();
			}

			for (uniformName in shaderExtensionInfo.uniforms.keys()) {
				if (!shaderInfo.uniforms.exists(uniformName)) {

					var uniformInfoClone = cloneUniformInfo(shaderExtensionInfo.uniforms.get(uniformName));
					shaderInfo.uniforms.set(uniformName, uniformInfoClone);
				} else {
					XT.Warn("Duplicate uniform \"" + uniformName + "\" for shader \"" + shaderName + "\" with extension \"" + extensionName + "\"");
				}
			}
		}

		if (shaderExtensionInfo.attributes != null) {
			if (shaderInfo.attributes == null) {
				shaderInfo.attributes = new Map<String, AttributeInfo>();
			}

			for (attributeName in shaderExtensionInfo.attributes.keys()) {
				if (!shaderInfo.attributes.exists(attributeName)) {

					var attributeInfoClone = cloneAttributeInfo(shaderExtensionInfo.attributes.get(attributeName));
					shaderInfo.attributes.set(attributeName, attributeInfoClone);
				} else {
					XT.Warn("attribute \"" + attributeName + "\" for shader \"" + shaderName + "\" with extension \"" + extensionName + "\"");
				}
			}
		}
	}

	public static function processVariableForShaderConfig(shaderConfig:ShaderInfo, shaderVariable:ShaderVariable):Void {
		var variableName = "$" + shaderVariable.name;
		var value = shaderVariable.value;

		var preProcessed = StringFunctions.replace_all(shaderConfig.vertexProgram, variableName, value);
		shaderConfig.vertexProgram = preProcessed;
		preProcessed = StringFunctions.replace_all(shaderConfig.fragmentProgram, variableName, value);
		shaderConfig.fragmentProgram = preProcessed;

		if (shaderConfig.vertexDefines != null) {
			var processedDefined = new Array<String>();
			for (vertexDefine in shaderConfig.vertexDefines) {
				preProcessed = StringFunctions.replace_all(vertexDefine, variableName, value);
				processedDefined.push(preProcessed);
			}
			shaderConfig.vertexDefines = processedDefined;
		}

		if (shaderConfig.fragmentDefines != null) {
			var processedDefined = new Array<String>();
			for (fragmentDefine in shaderConfig.fragmentDefines) {
				preProcessed = StringFunctions.replace_all(fragmentDefine, variableName, value);
				processedDefined.push(preProcessed);
			}
			shaderConfig.fragmentDefines = processedDefined;
		}

		if (shaderConfig.uniforms != null) {
			for (uniform in shaderConfig.uniforms) {
				preProcessed = StringFunctions.replace_all(uniform.type, variableName, value);
				uniform.type = preProcessed;
				if (uniform.defaultValue != null) {
					preProcessed = StringFunctions.replace_all(uniform.defaultValue, variableName, value);
					uniform.defaultValue = preProcessed;
				}
				if (uniform.slot != null) {
					preProcessed = StringFunctions.replace_all(uniform.slot, variableName, value);
					uniform.slot = preProcessed;
				}
			}
		}
	}

	public static function processVariableForUniformGroupInfo(uniformGroupInfo:UniformGroupInfo, shaderVariable:ShaderVariable):Void {
		var variableName = "$" + shaderVariable.name;
		var value = shaderVariable.value;

		var preProcessed:String;
		if (uniformGroupInfo.vertexDefines != null) {
			var processedDefined = new Array<String>();
			for (vertexDefine in uniformGroupInfo.vertexDefines) {
				preProcessed = StringFunctions.replace_all(vertexDefine, variableName, value);
				processedDefined.push(preProcessed);
			}
			uniformGroupInfo.vertexDefines = processedDefined;
		}

		if (uniformGroupInfo.fragmentDefines != null) {
			var processedDefined = new Array<String>();
			for (fragmentDefine in uniformGroupInfo.fragmentDefines) {
				preProcessed = StringFunctions.replace_all(fragmentDefine, variableName, value);
				processedDefined.push(preProcessed);
			}
			uniformGroupInfo.fragmentDefines = processedDefined;
		}

		if (uniformGroupInfo.uniforms != null) {
			for (uniform in uniformGroupInfo.uniforms) {
				preProcessed = StringFunctions.replace_all(uniform.type, variableName, value);
				uniform.type = preProcessed;
				if (uniform.defaultValue != null) {
					preProcessed = StringFunctions.replace_all(uniform.defaultValue, variableName, value);
					uniform.defaultValue = preProcessed;
				}
				if (uniform.slot != null) {
					preProcessed = StringFunctions.replace_all(uniform.slot, variableName, value);
					uniform.slot = preProcessed;
				}
			}
		}
	}


	public static function buildShaderTypesText(types:Map<String, Array<BaseTypeInfo>>):Map<String, String> {
		var shaderTypeTexts = new Map<String, String>();
		if (types != null) {
			for (typeName in types.keys()) {
				var typeDefinition = types.get(typeName);

				var shaderTypeText = "struct " + typeName + " {\n";

				for (baseType in typeDefinition) {
					shaderTypeText += "\t" + baseType.type + " " + baseType.name + ";\n";
				}

				shaderTypeText += "};\n\n";

				shaderTypeTexts.set(typeName, shaderTypeText);
			}
		}

		return shaderTypeTexts;
	}

	public static function buildUniformDeclaration(uniformInfo:UniformInfo):String {
		if (uniformIsArray(uniformInfo)) {
			var uniformType = uniformType(uniformInfo);
			var type = uniformCodeTypeFromBaseType(uniformType);
			var arraySize = uniformArraySize(uniformInfo);

			return "uniform " + type + " " + uniformInfo.name + "[" +arraySize + "];\n";

		} else {
			var type = uniformCodeTypeFromBaseType(uniformInfo.type);

			return "uniform " + type + " " + uniformInfo.name + ";\n";
		}
	}

	public static function uniformCodeTypeFromBaseType(uniformType:String):String {
		if (uniformType == "texture") {
			return "sampler2D";
		} else {
			return uniformType;
		}
	}


	public static function uniformType(uniformInfo:UniformInfo):String {
		var rawType = uniformInfo.type;
		if (!uniformIsArray(uniformInfo)) {
			return rawType;
		} else {
			var bracketIndex = rawType.indexOf("[");
			return rawType.substr(0, bracketIndex);
		}
	}

	public static function uniformArraySize(uniformInfo:UniformInfo):Int {
		var rawType = uniformInfo.type;
		var leftBracketIndex = rawType.indexOf("[");
		var rightBracketIndex = rawType.indexOf("]");

		if (leftBracketIndex == -1 || leftBracketIndex == -1) {
			throw new XTException("IncoherentUniformArrayDeclaration", "The uniform \"" + uniformInfo.name + "\" has incoherent array declaration: " + uniformInfo.type);
		}

		var stringValue = uniformInfo.type.substring(leftBracketIndex + 1, rightBracketIndex);

		return Std.parseInt(stringValue);
	}

	public static function uniformIsArray(uniformInfo:UniformInfo):Bool {
		var rawType = uniformInfo.type;
		var bracketIndex = rawType.indexOf("[");
		return (bracketIndex != -1);
	}

	public static function uniformIsCustomType(uniformInfo:UniformInfo):Bool {
		var uniformType = uniformType(uniformInfo);

		if (uniformType == "float" ||
			uniformType == "int" ||
			uniformType == "bool" ||
			uniformType == "vec2" ||
			uniformType == "vec3" ||
			uniformType == "vec4" ||
			uniformType == "mat2" ||
			uniformType == "mat3" ||
			uniformType == "mat4" ||
			uniformType == "texture") {

			return false;
		}
		return true;
	}

	public static function uniformInfoForArrayIndex(uniformInfo:UniformInfo, index:Int):UniformInfo {
		if (uniformIsArray(uniformInfo)) {
			var clone = cloneUniformInfo(uniformInfo);
			clone.type = uniformType(uniformInfo);
			clone.name = clone.name + "[" + index + "]";
			return clone;

		} else {
			XT.Warn("trying to create an array uniform info from non-array type");
			return null;
		}

	}

	public static function uniformNameForArrayIndex(name:String, index:Int):String {
		return name + "[" + index + "]";
	}

	public static function uniformInfoForTypeMember(uniformInfo:UniformInfo, baseTypeInfo:BaseTypeInfo):UniformInfo {
		if (uniformIsCustomType(uniformInfo)) {
			var clone = cloneUniformInfo(uniformInfo);
			clone.type = baseTypeInfo.type;
			clone.name = clone.name + "." + baseTypeInfo.name;
			clone.defaultValue = baseTypeInfo.defaultValue;
			return clone;

		} else {
			XT.Warn("trying to create a custom uniform info from base type : " + uniformInfo.type);
			return null;
		}
	}

	public static function uniformNameForTypeMember(name:String, baseTypeInfo:BaseTypeInfo):String {
		return name + "." + baseTypeInfo.name;
	}
}
