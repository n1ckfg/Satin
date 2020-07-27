//
//  Types.c
//  Satin
//
//  Created by Reza Ali on 7/5/20.
//

#include <malloc/_malloc.h>
#include <string.h>

#include "Geometry.h"
#include "Types.h"

void freeGeometryData(GeometryData *data) {
    if (data->vertexCount > 0 && data->vertexData == NULL) { return; }
    free(data->vertexData);

    if (data->indexCount > 0 && data->indexData == NULL) { return; }
    free(data->indexData);
}

void combineIndexGeometryData(GeometryData *dest, GeometryData *src,
                              int destPreCombineVertexCount) {
    if (src->indexCount > 0) {
        if (dest->indexCount > 0) {
            int totalCount = src->indexCount + dest->indexCount;
            dest->indexData = realloc(dest->indexData, totalCount * sizeof(TriangleIndices));
            memcpy(dest->indexData + dest->indexCount, src->indexData,
                   src->indexCount * sizeof(TriangleIndices));
            if (destPreCombineVertexCount > 0) {
                for (int i = dest->indexCount; i < totalCount; i++) {
                    dest->indexData[i].i0 += destPreCombineVertexCount;
                    dest->indexData[i].i1 += destPreCombineVertexCount;
                    dest->indexData[i].i2 += destPreCombineVertexCount;
                }
            }
            dest->indexCount += src->indexCount;
        } else {
            dest->indexData = (TriangleIndices *)malloc(sizeof(TriangleIndices) * src->indexCount);
            memcpy(dest->indexData, src->indexData, sizeof(TriangleIndices) * src->indexCount);
            dest->indexCount = src->indexCount;
        }
    }
}

void combineGeometryData(GeometryData *dest, GeometryData *src) {
    int destPreCombineVertexCount = dest->vertexCount;

    if (src->vertexCount > 0) {
        if (dest->vertexCount > 0) {
            int totalCount = src->vertexCount + dest->vertexCount;
            dest->vertexData = realloc(dest->vertexData, totalCount * sizeof(Vertex));
            memcpy(dest->vertexData + dest->vertexCount, src->vertexData,
                   src->vertexCount * sizeof(Vertex));
            dest->vertexCount += src->vertexCount;
        } else {
            dest->vertexData = (Vertex *)malloc(src->vertexCount * sizeof(Vertex));
            memcpy(dest->vertexData, src->vertexData, src->vertexCount * sizeof(Vertex));
            dest->vertexCount = src->vertexCount;
        }
    }

    combineIndexGeometryData(dest, src, destPreCombineVertexCount);
}

void combineAndOffsetGeometryData(GeometryData *dest, GeometryData *src, simd_float3 offset) {
    int destPreCombineVertexCount = dest->vertexCount;

    if (src->vertexCount > 0) {
        if (dest->vertexCount > 0) {
            int totalCount = src->vertexCount + dest->vertexCount;
            dest->vertexData = realloc(dest->vertexData, totalCount * sizeof(Vertex));
            memcpy(dest->vertexData + dest->vertexCount, src->vertexData,
                   src->vertexCount * sizeof(Vertex));
            for (int i = dest->vertexCount; i < totalCount; i++) {
                dest->vertexData[i].position += simd_make_float4(offset.x, offset.y, offset.z, 0.0);
            }
            dest->vertexCount += src->vertexCount;
        } else {
            dest->vertexData = (Vertex *)malloc(src->vertexCount * sizeof(Vertex));
            memcpy(dest->vertexData, src->vertexData, src->vertexCount * sizeof(Vertex));
            for (int i = 0; i < src->vertexCount; i++) {
                dest->vertexData[i].position += simd_make_float4(offset.x, offset.y, offset.z, 0.0);
            }
            dest->vertexCount = src->vertexCount;
        }
    }

    combineIndexGeometryData(dest, src, destPreCombineVertexCount);
}

void combineAndScaleGeometryData(GeometryData *dest, GeometryData *src, simd_float3 scale) {
    int destPreCombineVertexCount = dest->vertexCount;

    if (src->vertexCount > 0) {
        if (dest->vertexCount > 0) {
            int totalCount = src->vertexCount + dest->vertexCount;
            dest->vertexData = realloc(dest->vertexData, totalCount * sizeof(Vertex));
            memcpy(dest->vertexData + dest->vertexCount, src->vertexData,
                   src->vertexCount * sizeof(Vertex));
            for (int i = dest->vertexCount; i < totalCount; i++) {
                dest->vertexData[i].position *= simd_make_float4(scale.x, scale.y, scale.z, 1.0);
            }
            dest->vertexCount += src->vertexCount;
        } else {
            dest->vertexData = (Vertex *)malloc(src->vertexCount * sizeof(Vertex));
            memcpy(dest->vertexData, src->vertexData, src->vertexCount * sizeof(Vertex));
            for (int i = 0; i < src->vertexCount; i++) {
                dest->vertexData[i].position *= simd_make_float4(scale.x, scale.y, scale.z, 1.0);
            }
            dest->vertexCount = src->vertexCount;
        }
    }

    combineIndexGeometryData(dest, src, destPreCombineVertexCount);
}

void combineAndScaleAndOffsetGeometryData(GeometryData *dest, GeometryData *src, simd_float3 scale,
                                          simd_float3 offset) {
    int destPreCombineVertexCount = dest->vertexCount;

    if (src->vertexCount > 0) {
        if (dest->vertexCount > 0) {
            int totalCount = src->vertexCount + dest->vertexCount;
            dest->vertexData = realloc(dest->vertexData, totalCount * sizeof(Vertex));
            memcpy(dest->vertexData + dest->vertexCount, src->vertexData,
                   src->vertexCount * sizeof(Vertex));
            for (int i = dest->vertexCount; i < totalCount; i++) {
                dest->vertexData[i].position *= simd_make_float4(scale.x, scale.y, scale.z, 1.0);
                dest->vertexData[i].position += simd_make_float4(offset.x, offset.y, offset.z, 0.0);
            }
            dest->vertexCount += src->vertexCount;
        } else {
            dest->vertexData = (Vertex *)malloc(src->vertexCount * sizeof(Vertex));
            memcpy(dest->vertexData, src->vertexData, src->vertexCount * sizeof(Vertex));
            for (int i = 0; i < src->vertexCount; i++) {
                dest->vertexData[i].position *= simd_make_float4(scale.x, scale.y, scale.z, 1.0);
                dest->vertexData[i].position += simd_make_float4(offset.x, offset.y, offset.z, 0.0);
            }
            dest->vertexCount = src->vertexCount;
        }
    }

    combineIndexGeometryData(dest, src, destPreCombineVertexCount);
}

void copyGeometryData(GeometryData *dest, GeometryData *src) {
    if (src->vertexCount > 0) {
        dest->vertexCount = src->vertexCount;
        dest->vertexData = (Vertex *)malloc(src->vertexCount * sizeof(Vertex));
        memcpy(dest->vertexData, src->vertexData, src->vertexCount * sizeof(Vertex));
    }

    if (src->indexCount > 0) {
        dest->indexCount = src->indexCount;
        dest->indexData = (TriangleIndices *)malloc(sizeof(TriangleIndices) * src->indexCount);
        memcpy(dest->indexData, src->indexData, sizeof(TriangleIndices) * src->indexCount);
    }
}

void computeNormalsOfGeometryData(GeometryData *data) {
    int count = data->indexCount;
    if (count > 0) {
        for (int i = 0; i < count; i++) {
            uint32_t i0 = data->indexData[i].i0;
            uint32_t i1 = data->indexData[i].i1;
            uint32_t i2 = data->indexData[i].i2;

            Vertex v0 = data->vertexData[i0];
            Vertex v1 = data->vertexData[i1];
            Vertex v2 = data->vertexData[i2];

            simd_float3 p0 = simd_make_float3(v0.position);
            simd_float3 p1 = simd_make_float3(v1.position);
            simd_float3 p2 = simd_make_float3(v2.position);

            simd_float3 normal = simd_normalize(simd_cross(p1 - p0, p2 - p0));

            if (simd_length(normal) > 0) {
                float l0 = simd_length(v0.normal);
                v0.normal += normal;
                if (l0 > 0.0) { v0.normal *= 0.5; }
                data->vertexData[i0].normal = v0.normal;

                float l1 = simd_length(v1.normal);
                v1.normal += normal;
                if (l1 > 0.0) { v1.normal *= 0.5; }
                data->vertexData[i1].normal = v1.normal;

                float l2 = simd_length(v2.normal);
                v2.normal += normal;
                if (l2 > 0.0) { v2.normal *= 0.5; }
                data->vertexData[i2].normal = v2.normal;
            }
        }
    }
}

void reverseFacesOfGeometryData(GeometryData *data) {
    int indexCount = data->indexCount;
    if (indexCount > 0) {
        for (int i = 0; i < indexCount; i++) {
            uint32_t i1 = data->indexData[i].i1;
            uint32_t i2 = data->indexData[i].i2;
            data->indexData[i].i1 = i2;
            data->indexData[i].i2 = i1;
        }
    }

    int vertexCount = data->vertexCount;
    if (vertexCount > 0) {
        for (int i = 0; i < vertexCount; i++) {
            data->vertexData[i].normal *= -1.0;
        }
    }
}