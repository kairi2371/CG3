#include "Object3d.hlsli"

struct Material
{
    float32_t4 color;
    int32_t enableLighting;
    float32_t shininess;
};

struct DirectionalLight
{
    float32_t4 color;
    float32_t3 direction;
    float intensity;
};

struct Camera
{
    float32_t3 worldPosition;
};

ConstantBuffer<Material> gMaterial : register(b0);
ConstantBuffer<DirectionalLight> gDirectionalLight : register(b1);
ConstantBuffer<Camera> gCamera : register(b2);

struct PixelShaderOutput
{
    float32_t4 color : SV_TARGET0;
};

PixelShaderOutput main(VertexShaderOutput input)
{
    PixelShaderOutput output;
    if (gMaterial.enableLighting != 0)
    {
        
        float32_t3 toEye = normalize(gCamera.worldPosition - input.worldPosition);
        float32_t3 reflectLight = reflect(gDirectionalLight.direction, normalize(input.normal));
        float RdotE = dot(reflectLight, toEye);
        float specularPow = pow(saturate(RdotE), gMaterial.shininess);
        float cos = saturate(dot(normalize(input.normal), -gDirectionalLight.direction));
        //float NdotL = dot(normalize(input.normal) - gDirectionalLight.direction);
        //float cos = pow(NdotL * 0.5f + 0.5f, 2.0f);
        //output.color = gMaterial.color * gDirectionalLight.color * cos * gDirectionalLight.intensity;
    
        //拡散反射
        float32_t3 diffuse = gMaterial.color.rgb * gDirectionalLight.color.rgb * cos * gDirectionalLight.intensity;
        float32_t3 specular = gDirectionalLight.color.rgb * gDirectionalLight.intensity * specularPow * float32_t3(1.0f, 1.0f, 1.0f);
        //拡散反射+鏡面反射
        output.color.rgb = diffuse + specular;
        //アルファは今まで通り
        output.color.a = gMaterial.color.a;

    }
    else
    {
        output.color = gMaterial.color;
    }
    return output;
}