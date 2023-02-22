DEFSYSV, '!PROJECT', '/Users/haruto/idl/project/yashima_dmsp'
 
; color
DEVICE, DECOMPOSED=0
!P.BACKGROUND=255
LOADCT, 39
!P.COLOR=0


import, '~/idl/lib', /recur 
import, '~/idl/spedas_5_0', /recur


setenv, 'SPEDAS_DATA_DIR='+getenv('DATA_PATH')
