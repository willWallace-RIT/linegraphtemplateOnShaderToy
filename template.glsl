//Shader by northbot

// simplex noise from: https://www.shadertoy.com/view/ttlfRH


float random (in vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898,78.233))) * 43758.5453123);
}

float simplexValue1DPart(vec2 uv, float ix) {
    float x = uv.x - ix;
    float f = 1.0 - x * x;
    float f2 = f * f;
    float f3 = f * f2;
    return f3;
}

float simplexValue1D(vec2 uv) {
    vec2 iuv = floor(uv);    
    float n = simplexValue1DPart(uv, iuv.x);
    n += simplexValue1DPart(uv, iuv.x + 1.0);
    return random(vec2(n * 2.0 - 1.0, 0.0));

    
}



void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    
    float formulas[2]; // contains the formulas; size adjust for number of formulas
    int formArrSize = 2;  //size of dat array; size adjust for number of formulas
    float formSimpIdex[2]; // contains the seed value used for randoming;
    float randEdgeThresh=0.01; //trim the edge a bit
    float lineThresh = 0.01;
    float fuzzyWuzzyMinimizer = 0.4; 
    vec3 rgbiets[2];
    vec2 uv = fragCoord / iResolution.xy;
    
    formulas[0] = cos(uv.x);
    formulas[1] = sin(uv.x);
   
   
    vec3 col = vec3(0.0,0.0,0.0);
    for(int i = 0; i < formArrSize;i++){
       float x = randEdgeThresh+(((1.0-(randEdgeThresh*2.0))/float(formArrSize))*float(i));
       float r = simplexValue1D(vec2(x,x));
       float g = simplexValue1D(vec2(r,r));
       float b = simplexValue1D(vec2(r,g));
       rgbiets[i] = vec3(r,g,b);
    }
    
    for(int j = 0; j<=formArrSize;j++){
       if((uv.y >= formulas[j]-lineThresh) &&(uv.y <= formulas[j]+lineThresh)){
         col += rgbiets[j];
       }
    }
   
    // Output to screen
    fragColor = vec4(col*fuzzyWuzzyMinimizer,1.0);
}
