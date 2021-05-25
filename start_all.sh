#!/bin/bash
matlab -nosplash -nodisplay -nodesktop -r "generate_runtime_data('m1');exit;"
matlab -nosplash -nodisplay -nodesktop -r "generate_runtime_data('m2');exit;"
matlab -nosplash -nodisplay -nodesktop -r "generate_runtime_data('n');exit;"
matlab -nosplash -nodisplay -nodesktop -r "generate_runtime_data('o_st');exit;"
