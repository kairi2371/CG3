struct VertexShaderOutput
{
    float32_t4 position : SV_POSITION;
    float32_t2 texcoord : TEXCOORDO;
    float32_t3 normal : NORMALO;
    float32_t3 worldPosition : POSITIONO;
};