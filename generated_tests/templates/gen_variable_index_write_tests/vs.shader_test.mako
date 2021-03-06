## Copyright (c) 2015-2016 Intel Corporation
##
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included in
## all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
## SOFTWARE.
<%!
  import textwrap

  def strip_newlines(block):
    return '\n'.join(l for l in block.splitlines() if l.strip())
%>
<%namespace name="helpers" file="helpers.mako"/>

# Autogenerated test -- DO NOT EDIT

${helpers.license()}

[require]
GLSL >= ${params.version.print_float()}
% if params.mode == 'varying':
  GL_MAX_VARYING_COMPONENTS >= ${params.varying_comps}
% endif

[vertex shader]
${helpers.emit_globals(params)}

<%block filter="textwrap.dedent,strip_newlines">
  % if params.mode != 'varying':
    ${helpers.emit_distanceSqr_function(params.matrix_dim)}
  % endif
</%block>

void main()
{
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
  
  ${helpers.emit_set_matrix(params)}
  ${helpers.emit_transform(params)}

  % if params.mode != 'varying':
    gl_FrontColor = (distanceSqr(dst_matrix${params.idx2} * v, expect) < 4e-9)
      ? vec4(0.0, 1.0, 0.0, 1.0) : vec4(1.0, 0.0, 0.0, 1.0);
  % endif
}

<%block filter="textwrap.dedent">
  % if params.mode != 'varying':
    [fragment shader]
    void main() { gl_FragColor = gl_Color; }
  % else:
    ${helpers.emit_fs(params)}
  % endif
</%block>

[test]
clear color 0.5 0.5 0.5 0.5
clear
ortho

${helpers.emit_test_vectors(params)}
