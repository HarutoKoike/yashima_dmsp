DEFSYSV, '!PROJECT', GETENV('IDLENV_PROJECT_PATH')
;
; graphic settings
loadct, 39
!p.color=0
!p.background=255
device, decomposed=0


;
; data storage 
if getenv('USER') eq 'h.koike' then $
    setenv, 'DATA_PATH=/Users/h.koike/data'
if getenv('USER') eq 'haruto' then $
    setenv, 'DATA_PATH=/Volumes/spel_data/10Spacecrafts'
 

;
; libraries
import, '~/idl/spedas_5_0', /recur
import, '~/idl/dmsp_load', /recur
import, '~/idl/myidltools', /recur
