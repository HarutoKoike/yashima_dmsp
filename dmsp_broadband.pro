
PRO dmsp_broadband, yyyy, mm, f

;
;*---------- days  ----------*
;
days = JULDAY(mm + 1, 1, yyyy) - JULDAY(mm, 1, yyyy)
days = INDGEN(days) + 1



;
;*---------- output file  ----------*
;
; 'F16_2010_01.txt'
fn = 'F' + STRING(f, FORMAT='(I02)') + STRING(yyyy, FORMAT='(I4)') + $ 
     '_' + STRING(mm, FORMAT='(I02)') + '.txt'
fn = '~/' + fn



;
;*---------- write  ----------*
;
; open file
OPENW, lun, fn, /GET_LUN
;
; roop for days
;
ref_eflux = 1.e9  ; 10^9 eV/eV cm^2 sr s ; electron differential energy flux
;
;
FOREACH dd, days DO BEGIN
  ;
  ; load DMSP data
  dmsp = dmsp_load(f, yyyy, mm, dd)
  IF ISA(dmsp, 'INT') THEN CONTINUE
  ;
  t         = dmsp.t             ; time(UNIX time)
  mlt       = dmsp.mlt           ; MLT
  mlat      = dmsp.mlat          ; MLAT
  eflux95   = dmsp.jee[15, *]    ; 95eV  electron differential energy flux
  eflux139  = dmsp.jee[14, *]    ; 139eV electron differential energy flux
  ;
  d_mlt   = ~(mlt GE 6. AND mlt LT 18)      ; 0<=MLT<=6 or 18<=MLT<=24 
  d_mlat  = (mlat GE 68) AND (mlat LE 85)   ; 68 <= MLAT <= 85
  d_eflux = (eflux95 GE ref_eflux) AND (eflux139 GE ref_eflux) 
  ds      = d_mlt AND d_mlat AND d_eflux
  ;
  ds = [0, ds] - [ds, 0]
  idx_st = WHERE(ds EQ -1, count)  ; start
  idx_ed = WHERE(ds EQ 1) - 1      ; end
  IF count EQ 0 THEN CONTINUE
  ;
  duration = idx_ed - idx_st + 1    
  IF MAX(duration) LT 3 THEN CONTINUE
  ;
  idx_st = idx_st[ WHERE(duration GE 3) ]
  idx_ed = idx_et[ WHERE(duration GE 3) ]
  ;
  ut_start = time_string(t[idx_st])
  ut_end   = time_string(t[idx_ed])  ; '2000-01-01/00:00:00' format=(A19)
 

  ;
  ; write 
  ;
  ; 1:UT(start), 2:UT(end), 3:maximum 95eV electron flux, 4:UT(maximum), 
  ; 6:MLT(maximum), 7:MLAT(maximum)
  ;
  FOR i = 0, N_ELEMENTS(idx_st) - 1 DO BEGIN
    eflux95_max = MAX( eflux95[idx_st[i]:idx_et[i]], /NAN, idx_max )
    idx_max    += idx_st[i]
    ut_max      = time_string( t[idx_max] )
    mlt_max     = mlt[idx_max]
    mlat_max    = mlat[idx_max]
    ;
    PRINTF, lun, ut_start[i], ut_end[i], eflux95_max, ut_max, mlt_max, mlat_max, $
            FORMAT='(A19, A19, E10.3, A19, F7.2, F7.2)'
  ENDFOR

ENDFOREACH
;
FREE_LUN, lun


END
