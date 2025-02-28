//
//  Shaders.metal
//  Satin
//
//  Created by Reza Ali on 2/9/22.
//

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

typedef enum VertexAttribute {
    VertexAttributePosition = 0,
    VertexAttributeNormal = 1,
    VertexAttributeTexcoord = 2,
    VertexAttributeTangent = 3,
    VertexAttributeBitangent = 4,
    VertexAttributeColor = 5,
    VertexAttributeCustom0 = 6,
    VertexAttributeCustom1 = 7,
    VertexAttributeCustom2 = 8,
    VertexAttributeCustom3 = 9,
    VertexAttributeCustom4 = 10,
    VertexAttributeCustom5 = 11,
    VertexAttributeCustom6 = 12,
    VertexAttributeCustom7 = 13,
    VertexAttributeCustom8 = 14,
    VertexAttributeCustom9 = 15,
    VertexAttributeCustom10 = 16,
    VertexAttributeCustom11 = 17
} VertexAttribute;

typedef enum VertexBufferIndex {
    VertexBufferVertices = 0,
    VertexBufferGenerics = 1,
    VertexBufferVertexUniforms = 2,
    VertexBufferInstanceMatrixUniforms = 3,
    VertexBufferMaterialUniforms = 4,
    VertexBufferCustom0 = 5,
    VertexBufferCustom1 = 6,
    VertexBufferCustom2 = 7,
    VertexBufferCustom3 = 8,
    VertexBufferCustom4 = 9,
    VertexBufferCustom5 = 10,
    VertexBufferCustom6 = 11,
    VertexBufferCustom7 = 12,
    VertexBufferCustom8 = 13,
    VertexBufferCustom9 = 14,
    VertexBufferCustom10 = 15
} VertexBufferIndex;

typedef enum VertexTextureIndex {
    VertexTextureCustom0 = 0,
    VertexTextureCustom1 = 1,
    VertexTextureCustom2 = 2,
    VertexTextureCustom3 = 3,
    VertexTextureCustom4 = 4,
    VertexTextureCustom5 = 5,
    VertexTextureCustom6 = 6,
    VertexTextureCustom7 = 7,
    VertexTextureCustom8 = 8,
    VertexTextureCustom9 = 9,
    VertexTextureCustom10 = 10
} VertexTextureIndex;

typedef enum FragmentBufferIndex {
    FragmentBufferMaterialUniforms = 0,
    FragmentBufferLighting = 1,
    FragmentBufferShadows = 2,
    FragmentBufferCustom0 = 3,
    FragmentBufferCustom1 = 4,
    FragmentBufferCustom2 = 5,
    FragmentBufferCustom3 = 6,
    FragmentBufferCustom4 = 7,
    FragmentBufferCustom5 = 8,
    FragmentBufferCustom6 = 9,
    FragmentBufferCustom7 = 10,
    FragmentBufferCustom8 = 11,
    FragmentBufferCustom9 = 12,
    FragmentBufferCustom10 = 13
} FragmentBufferIndex;

typedef enum FragmentTextureIndex {
    FragmentTextureCustom0 = 0,
    FragmentTextureCustom1 = 1,
    FragmentTextureCustom2 = 2,
    FragmentTextureCustom3 = 3,
    FragmentTextureCustom4 = 4,
    FragmentTextureCustom5 = 5,
    FragmentTextureCustom6 = 6,
    FragmentTextureCustom7 = 7,
    FragmentTextureCustom8 = 8,
    FragmentTextureCustom9 = 9,
    FragmentTextureCustom10 = 10,
    FragmentTextureShadow0 = 11,
    FragmentTextureShadow1 = 12,
    FragmentTextureShadow2 = 13,
    FragmentTextureShadow3 = 14,
    FragmentTextureShadow4 = 15,
    FragmentTextureShadow5 = 16,
    FragmentTextureShadow6 = 17,
    FragmentTextureShadow7 = 18
} FragmentTextureIndex;

typedef enum PBRTextureIndex {
    PBRTextureBaseColor = 0,
    PBRTextureMetallic = 1,
    PBRTextureRoughness = 2,
    PBRTextureNormal = 3,
    PBRTextureEmissive = 4,
    PBRTextureSpecular = 5,
    PBRTextureSheen = 6,
    PBRTextureAnisotropy = 7,
    PBRTextureAnisotropyAngle = 8,
    PBRTextureBump = 9,
    PBRTextureDisplacement = 10,
    PBRTextureAlpha = 11,
    PBRTextureAmbient = 12,
    PBRTextureAmbientOcclusion = 13,
    PBRTextureReflection = 14,
    PBRTextureIrradiance = 15,
    PBRTextureBrdf = 16
} PBRTextureIndex;

typedef enum PBRSamplerIndex {
    PBRSamplerBaseColor = 0,
    PBRSamplerMetallic = 1,
    PBRSamplerRoughness = 2,
    PBRSamplerNormal = 3,
    PBRSamplerEmissive = 4,
    PBRSamplerSpecular = 5,
    PBRSamplerSheen = 6,
    PBRSamplerAnisotropy = 7,
    PBRSamplerAnisotropyAngle = 8,
    PBRSamplerBump = 9,
    PBRSamplerDisplacement = 10,
    PBRSamplerAlpha = 11,
    PBRSamplerAmbient = 12,
    PBRSamplerAmbientOcclusion = 13,
    PBRSamplerReflection = 14,
    PBRSamplerIrradiance = 15,
    PBRSamplerBrdf = 16
} PBRSamplerIndex;

typedef enum FragmentSamplerIndex {
    FragmentSamplerCustom0 = 0,
    FragmentSamplerCustom1 = 1,
    FragmentSamplerCustom2 = 2,
    FragmentSamplerCustom3 = 3,
    FragmentSamplerCustom4 = 4,
    FragmentSamplerCustom5 = 5,
    FragmentSamplerCustom6 = 6,
    FragmentSamplerCustom7 = 7,
    FragmentSamplerCustom8 = 8,
    FragmentSamplerCustom9 = 9,
    FragmentSamplerCustom10 = 10
} FragmentSamplerIndex;

typedef enum ComputeBufferIndex {
    ComputeBufferUniforms = 0,
    ComputeBufferCustom0 = 1,
    ComputeBufferCustom1 = 2,
    ComputeBufferCustom2 = 3,
    ComputeBufferCustom3 = 4,
    ComputeBufferCustom4 = 5,
    ComputeBufferCustom5 = 6,
    ComputeBufferCustom6 = 7,
    ComputeBufferCustom7 = 8,
    ComputeBufferCustom8 = 9,
    ComputeBufferCustom9 = 10,
    ComputeBufferCustom10 = 11
} ComputeBufferIndex;

typedef enum ComputeTextureIndex {
    ComputeTextureCustom0 = 0,
    ComputeTextureCustom1 = 1,
    ComputeTextureCustom2 = 2,
    ComputeTextureCustom3 = 3,
    ComputeTextureCustom4 = 4,
    ComputeTextureCustom5 = 5,
    ComputeTextureCustom6 = 6,
    ComputeTextureCustom7 = 7,
    ComputeTextureCustom8 = 8,
    ComputeTextureCustom9 = 9,
    ComputeTextureCustom10 = 10
} ComputeTextureIndex;

typedef struct {
    float4 position [[attribute(VertexAttributePosition)]];
    float3 normal [[attribute(VertexAttributeNormal)]];
    float2 uv [[attribute(VertexAttributeTexcoord)]];
} Vertex;

typedef struct {
    float4 position [[position]];
    float3 normal;
    float2 uv;
} VertexData;

typedef struct {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 modelViewMatrix;
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 viewProjectionMatrix;
    matrix_float4x4 modelViewProjectionMatrix;
    matrix_float4x4 inverseModelViewProjectionMatrix;
    matrix_float4x4 inverseViewMatrix;
    matrix_float3x3 normalMatrix;
    float4 viewport;
    float3 worldCameraPosition;
    float3 worldCameraViewDirection;
} VertexUniforms;

typedef struct {
    float4 color; //color
    float3 three;
    float2 two;
    float one;
    int zero;
    bool absolute; //toggle
} NormalColorUniforms;

vertex VertexData normalColorVertex(Vertex in [[stage_in]],
                              constant VertexUniforms &vertexUniforms
                              [[buffer(VertexBufferVertexUniforms)]]) {
    VertexData out;
    out.position = vertexUniforms.modelViewProjectionMatrix * in.position;
    out.normal = normalize(vertexUniforms.normalMatrix * in.normal);
    out.uv = in.uv;
    return out;
}

fragment float4 normalColorFragment(VertexData in [[stage_in]],
                                    constant NormalColorUniforms &uniforms
                                    [[buffer(FragmentBufferMaterialUniforms)]]) {
    return uniforms.color * float4(uniforms.absolute ? abs(in.normal) : in.normal, 1.0);
}
