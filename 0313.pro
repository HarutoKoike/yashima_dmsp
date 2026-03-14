
d = dmsp_load(17, 2015, 1, 14)



idx1 = 8*3600L + 18*60L
idx2 = 8*3600L + 30*60L

idx  = [idx1:idx2]
t    = d.t[idx]
glat = d.glat[idx]
glon = d.glon[idx]
alt  = d.alti[idx]
 

hr  = time_string(t, tform='hh')
min = time_string(t, tform='mm')
sec = time_string(t, tform='ss')

header = 'hh mm ss glat glon altitude'
format = '(3(I02, 1x), 3(F8.3, 1x))' 
fn     = 'F17_20150114.txt'

io->write_ascii, fn, hr, min, sec, glat, glon, alt, format=format, header=header


end
