#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern MY_HIGHP_OR_MEDIUMP vec2 offset;

float plot(vec2 uv, float pct)
{
    return smoothstep(pct+0.02,pct, uv.y)
         - smoothstep(pct,pct-0.02, uv.y);
}

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    MY_HIGHP_OR_MEDIUMP vec4 tex = Texel(texture, texture_coords);
    MY_HIGHP_OR_MEDIUMP vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;
    
    vec2 offset_uv = uv / offset;

    float y = 1.0 - offset_uv.x;
    tex.a = tex.a * plot(uv, y);
    tex.rgb = vec3(0.6, 0.7, 1.0);

    return tex;
}
