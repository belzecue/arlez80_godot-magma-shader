/*
	Magma-ish Shader for Godot Engine by Yui Kinomoto @arlez80
	マグマ風シェーダー by あるる（きのもと 結衣） @arlez80

	MIT License
*/
shader_type spatial;
render_mode unshaded;

uniform vec2 splast_speed = vec2( 2.05, 1.6 );
uniform float splast_scale = 20.0;
uniform float splast_height = 0.4;

uniform vec2 speed = vec2( 0.02, 0.0 );
uniform sampler2D color : hint_albedo;

float random( vec2 pos )
{ 
	return fract(sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453);
}

float noise( vec2 pos )
{
	return random( floor( pos ) );
}

float value_noise( vec2 pos )
{
	vec2 p = floor( pos );
	vec2 f = fract( pos );

	float v00 = noise( p + vec2( 0.0, 0.0 ) );
	float v10 = noise( p + vec2( 1.0, 0.0 ) );
	float v01 = noise( p + vec2( 0.0, 1.0 ) );
	float v11 = noise( p + vec2( 1.0, 1.0 ) );

	vec2 u = f * f * ( 3.0 - 2.0 * f );

	return mix( mix( v00, v10, u.x ), mix( v01, v11, u.x ), u.y );
}

void vertex( )
{
	VERTEX.y = value_noise( UV * splast_scale + splast_speed * TIME ) * splast_height;
}

void fragment( )
{
	vec2 a = UV + speed * TIME;
	vec2 b = UV + speed * TIME * 0.85;
	vec2 c = UV + speed * TIME * 0.5456;
	vec2 d = UV + speed * TIME * 0.2;
	float h = (
		value_noise( a * 1.5433 )
	+	value_noise( b * 4.432 )
	+	value_noise( b * 8.4321 )
	+	value_noise( c * 64.54326 )
	+	value_noise( c * 128.76432 )
	+	value_noise( d * 256.5432 )
	+	value_noise( a * 512.4325423 )
	+	value_noise( d * 2615.4325423 )
	+	value_noise( a * 5432.423 )
	) / 9.0;

	ALBEDO = texture( color, vec2( h, 0.0 ) ).rgb;
	//EMISSION = ALBEDO * clamp( h2, 0.0, 1.0 );
}
