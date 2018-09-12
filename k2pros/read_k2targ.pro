function read_k2targ,kid,campaign,time,quality,flux_bkg,apmask,data=data,quicklook=quicklook

	if ~keyword_set(quicklook) then quicklook = 0b
	if campaign ge 10 then format ='(I2)' else format='(I1)'
	sdir = 'Campaign'+string(format=format,campaign)+'/tpf'
	cd, !workdir + '/' + sdir
	data=read_localfits(kid,/compress,/nonumbers)
	if (size(data,/tname) ne 'STRUCT') then begin
		print, 'read_k2targ: file not found in ',sdir,' for ',kid
	endif
	cd, '/home/eshaya/Documents/Kepler/K2'
        time = data.targettables.data.time
	
	if quicklook then begin
		k2cube = double(data.targettables.data.raw_cnts) 
		lcfxdoff = sxpar(data.targettables.header,'LCFXDOFF')
		meanblack = sxpar(data.targettables.header,'MEANBLACK')
		nreadout = sxpar(data.targettables.header,'NREADOUT')
		int_time = sxpar(data.targettables.header,'INT_TIME')
		num_frm = sxpar(data.targettables.header,'NUM_FRM')
		nans = where(k2cube eq -1)
		k2cube = double(k2cube - lcfxdoff + meanblack*nreadout)
		k2cube[nans] = !VALUES.D_NAN
	endif else k2cube = data.targettables.data.flux
	apmask = data.aperture.data
	wh = where(k2cube lt -100e0,nbad)
	if nbad gt 0 then k2cube[wh] = !VALUES.D_NAN
	timecorr = data.targettables.data.timecorr
	timslice=sxpar(data.targettables.header,'TIMSLICE')
        time = double(data.targettables.data.time) 
        time = time - timecorr+(0.25+0.52*(5.-timslice))/86400.
	quality = data.targettables.data.quality
	flux_bkg = data.targettables.data.flux_bkg
return,k2cube
end
