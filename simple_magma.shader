/*
	Magma-ish Shader for Godot Engine by Yui Kinomoto @arlez80
	マグマ風シェーダー by あるる（きのもと 結衣） @arlez80

	MIT License
*/
shader_type spatial;
render_mode unshaded;

uniform float speed = 0.05;
uniform sampler2D color;

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

void fragment( )
{
	vec2 a = UV + TIME * speed;
	vec2 b = UV - TIME * speed;
	vec2 c = UV + TIME * speed * vec2( 1, 1 ) * mat2( vec2( -1, 0 ), vec2( 0, 1 ) );
	vec2 d = UV + TIME * speed * vec2( 1, 1 ) * mat2( vec2( 1, 0 ), vec2( 0, -1 ) );
	float h = (
		value_noise( a * 1.0 )
	+	value_noise( b * 4.0 )
	+	value_noise( c * 8.0 )
	+	value_noise( d * 16.0 )
	+	value_noise( a * 64.0 )
	+	value_noise( b * 128.0 )
	+	value_noise( c * 256.0 )
	+	value_noise( d * 512.0 )
	) / 8.0;

	ALBEDO = texture( color, vec2( h, 0 ) ).xyz;
}

void light( )
{
	DIFFUSE_LIGHT = vec3( 1, 1, 1 );
}
