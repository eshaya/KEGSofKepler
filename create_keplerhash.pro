apphot = FLTARR(4398)
kid=7439819
ap = 2
apsize = 2*ap+1
phot = HASH(apsize,apphot)
phot['header'] = fltarr(200)
bykid = HASH(kid,phot)
bygroup = HASH(43,bykid)
byquarter = HASH(6,bygroup)