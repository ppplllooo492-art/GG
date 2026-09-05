local ii111l=(getfenv and getfenv(1)) or _ENV or _G
local IjI1jLjooLolI,lIiILoL=string.byte,string.char
local function iI0I1jLi1L(j0o0ILO0Ljj0Il,jijLL1lo1iLj)
local ljOiLiLlIi0I=""
local I0lli1ijl0I=#jijLL1lo1iLj
for iI0ilii=1,#j0o0ILO0Ljj0Il do ljOiLiLlIi0I=ljOiLiLlIi0I..lIiILoL((IjI1jLjooLolI(j0o0ILO0Ljj0Il,iI0ilii)-IjI1jLjooLolI(jijLL1lo1iLj,(iI0ilii-1)%I0lli1ijl0I+1))%256) end
return ljOiLiLlIi0I
end
local LoOli010Oi10I=ii111l[iI0I1jLi1L("YId\027IX","\230\228\248\182")]
local ji0oIj0Ill=ii111l[iI0I1jLi1L("\234\188\182\200\"\250","wHD_\180\147&")][iI0I1jLi1L("(*Y","\181\181\247H")]
local iIjLjlI00iOiIO=ii111l[iI0I1jLi1L("U\170\024,\222","\225I\182\192y\224\168")][iI0I1jLi1L("\239pjd\237\000","\140\001\252\001\140")]
local Lo1LjL1I100=ii111l[iI0I1jLi1L("A\144C\254","\212/\207\150\159T")][iI0I1jLi1L("|~\017Bu","\022\018\162\211\003K\251")]
local lli1jll=ii111l[iI0I1jLi1L("\150\170krnL\129\148","\";\253\253\001\234\028")]
local l1IiLjo=ii111l[iI0I1jLi1L("4\141N\2168","\207\027\220i\198")]
local jjj1ILoL0L1ilO=lli1jll("138")*4+(lIiILoL(89,89)=="YY" and 8056 or 77)+IjI1jLjooLolI("0")+LoOli010Oi10I("#",0,0)*17
local LLoIoi=ii111l[iI0I1jLi1L("\219\202\027\215:","gi\185k\213\249")][iI0I1jLi1L("\193r)\\","Q\017\198\241")] or function(...) return {n=LoOli010Oi10I("#",...),...} end
local ILOi11jIjOOo1j=ii111l[iI0I1jLi1L("\182\180\252\207\022","BS\154c\177\141\156")][iI0I1jLi1L("[i\204\191i\246","\230\251\\^\006\139")] or ii111l[iI0I1jLi1L("\231=\159X\247\162","r\207/\247\1487")]
local lOiOIoIiLoi="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function L00I1OIlOoii0j(jllojOIIiLil)
local lLL00i1={}
for jlooliI0iL0=1,64 do lLL00i1[IjI1jLjooLolI(lOiOIoIiLoi,jlooliI0iL0)]=jlooliI0iL0-1 end
local iL1Liji,io010ij,iI0IIoooii,LLLiiiiIoi={},0,0,0
for jlooliI0iL0=1,#jllojOIIiLil do
local jil1OiOLo01O1=lLL00i1[IjI1jLjooLolI(jllojOIIiLil,jlooliI0iL0)]
if jil1OiOLo01O1 then
io010ij=io010ij*64+jil1OiOLo01O1
iI0IIoooii=iI0IIoooii+6
if iI0IIoooii>=8 then iI0IIoooii=iI0IIoooii-8 LLLiiiiIoi=LLLiiiiIoi+1 iL1Liji[LLLiiiiIoi]=lIiILoL(Lo1LjL1I100(io010ij/(2^iI0IIoooii))%256) io010ij=io010ij%(2^iI0IIoooii) end
end
end
return iIjLjlI00iOiIO(iL1Liji)
end
local loj100I1jioO="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"
local function jL11j01(LO0O11I0LO1IiI)
local LO01jIli=(2001267134)+jjj1ILoL0L1ilO
local jjIioi0LL0i=197
local LOOil1jl={}
for I0oloo0IoL0l=1,#LO0O11I0LO1IiI do
LO01jIli=(LO01jIli*36963+2351157527)%4294967296
local IiOjOol0o1l=IjI1jLjooLolI(LO0O11I0LO1IiI,I0oloo0IoL0l)
local i1O0llj=(Lo1LjL1I100(LO01jIli/65536)+jjIioi0LL0i+(I0oloo0IoL0l-1)*163)%256
LOOil1jl[I0oloo0IoL0l]=lIiILoL((IiOjOol0o1l-i1O0llj)%256)
jjIioi0LL0i=(jjIioi0LL0i*41+IiOjOol0o1l+1)%251
end
return iIjLjlI00iOiIO(LOOil1jl)
end
local iLIljjoO=jL11j01(L00I1OIlOoii0j(loj100I1jioO))
local IiOjOol0o1l=1
local function jOLloojLo1()
local I0oloo0IoL0l=IjI1jLjooLolI(iLIljjoO,IiOjOol0o1l)
IiOjOol0o1l=IiOjOol0o1l+1
return I0oloo0IoL0l
end
local function Il0olOLL1O()
local I0oloo0IoL0l,i0i1ioO1=IjI1jLjooLolI(iLIljjoO,IiOjOol0o1l,IiOjOol0o1l+1)
IiOjOol0o1l=IiOjOol0o1l+2
return I0oloo0IoL0l+i0i1ioO1*256
end
local function jlLIij0()
local I0oloo0IoL0l,i0i1ioO1,LO0O11I0LO1IiI,LOOil1jl=IjI1jLjooLolI(iLIljjoO,IiOjOol0o1l,IiOjOol0o1l+3)
IiOjOol0o1l=IiOjOol0o1l+4
return I0oloo0IoL0l+i0i1ioO1*256+LO0O11I0LO1IiI*65536+LOOil1jl*16777216
end
local function iioolLOiiio0()
local I0oloo0IoL0l=jlLIij0()
local i0i1ioO1=ji0oIj0Ill(iLIljjoO,IiOjOol0o1l,IiOjOol0o1l+I0oloo0IoL0l-1)
IiOjOol0o1l=IiOjOol0o1l+I0oloo0IoL0l
return i0i1ioO1
end
local function jjooOolL1Ojl0O()
local I0oloo0IoL0l=jOLloojLo1()
local i0i1ioO1=iioolLOiiio0()
if I0oloo0IoL0l==0 then return lli1jll(i0i1ioO1)
elseif I0oloo0IoL0l==1 then return i0i1ioO1
elseif I0oloo0IoL0l==2 then return 1/0
elseif I0oloo0IoL0l==3 then return -1/0
else return 0/0 end
end
local function IIOIll()
local ilOOo1IIoI1=jOLloojLo1()
local I0oloo0IoL0l=jOLloojLo1()
local i0i1ioO1=Il0olOLL1O()
local jIooj00jol={}
for LO0O11I0LO1IiI=1,i0i1ioO1 do local jojLIolLOjl=Il0olOLL1O() jIooj00jol[LO0O11I0LO1IiI]={jojLIolLOjl,iioolLOiiio0()} end
local LOOil1jl=jlLIij0()
local j0OlllI1Loi={}
for LO0O11I0LO1IiI=1,LOOil1jl do
j0OlllI1Loi[LO0O11I0LO1IiI]={Il0olOLL1O(),Il0olOLL1O(),jlLIij0(),jlLIij0()}
end
local IiOjOol0o1l=Il0olOLL1O()
local lO1oioo={}
for LO0O11I0LO1IiI=1,IiOjOol0o1l do lO1oioo[LO0O11I0LO1IiI]=IIOIll() end
local I0LL0L11=Il0olOLL1O()
local loLij0LIioLljI={}
for LO0O11I0LO1IiI=1,I0LL0L11 do loLij0LIioLljI[LO0O11I0LO1IiI]={jOLloojLo1(),Il0olOLL1O()} end
return {ilOOo1IIoI1,I0oloo0IoL0l,j0OlllI1Loi,jIooj00jol,lO1oioo,loLij0LIioLljI,{}}
end
local function LiiI1LI0IlIL(iojiioi0lL0jj,IIj1OLOjlo1,jojLIolLOjl)
if IIj1OLOjlo1[jojLIolLOjl]~=nil then return IIj1OLOjlo1[jojLIolLOjl] end
local jllojOIIiLil=iojiioi0lL0jj[jojLIolLOjl]
local lLL00i1=jllojOIIiLil[1]
local jlooliI0iL0=jllojOIIiLil[2]
local iL1Liji=(62208+lLL00i1*251+1)%65536
local io010ij={}
for iI0IIoooii=1,#jlooliI0iL0 do
iL1Liji=(iL1Liji*40503+12345)%65536
io010ij[iI0IIoooii]=lIiILoL((IjI1jLjooLolI(jlooliI0iL0,iI0IIoooii)-Lo1LjL1I100(iL1Liji/256)%256-iI0IIoooii*(62208%256))%256)
end
local LLLiiiiIoi=iIjLjlI00iOiIO(io010ij)
local jil1OiOLo01O1=IjI1jLjooLolI(LLLiiiiIoi,1)
local II0IIolII=IjI1jLjooLolI(LLLiiiiIoi,2)+IjI1jLjooLolI(LLLiiiiIoi,3)*256+IjI1jLjooLolI(LLLiiiiIoi,4)*65536+IjI1jLjooLolI(LLLiiiiIoi,5)*16777216
local l0oLl10=ji0oIj0Ill(LLLiiiiIoi,6,5+II0IIolII)
local IoOoll
if jil1OiOLo01O1==0 then IoOoll=lli1jll(l0oLl10) elseif jil1OiOLo01O1==1 then IoOoll=l0oLl10 elseif jil1OiOLo01O1==2 then IoOoll=1/0 elseif jil1OiOLo01O1==3 then IoOoll=-1/0 else IoOoll=0/0 end
IIj1OLOjlo1[jojLIolLOjl]=IoOoll
return IoOoll
end
local looj1j0={}
local ljj0I0ij1O=Il0olOLL1O()
for IIO1oo=1,ljj0I0ij1O do local I0oloo0IoL0l=Il0olOLL1O() local i0i1ioO1=Il0olOLL1O() looj1j0[I0oloo0IoL0l]=i0i1ioO1 end
local iiIOLijIj=IIOIll()
local lOiOLLolj1I1O1
local function I11oII(iiIOLijIj,loLij0LIioLljI)
return function(...) return lOiOLLolj1I1O1(iiIOLijIj,loLij0LIioLljI,LLoIoi(...)) end
end
lOiOLLolj1I1O1=function(iiIOLijIj,loLij0LIioLljI,iLjOoiIOOI)
local ILlILoIj1OjOl={}
local LojjjIILLj1=0
local ilOOo1IIoI1=iiIOLijIj[1]
local jL01OolI=iLjOoiIOOI.n
for I0oloo0IoL0l=1,ilOOo1IIoI1 do ILlILoIj1OjOl[I0oloo0IoL0l-1]=iLjOoiIOOI[I0oloo0IoL0l] end
local iLjiOi,jl1OLiojI={},0
if iiIOLijIj[2]==1 then jl1OLiojI=jL01OolI-ilOOo1IIoI1; if jl1OLiojI<0 then jl1OLiojI=0 end; for I0oloo0IoL0l=1,jl1OLiojI do iLjiOi[I0oloo0IoL0l]=iLjOoiIOOI[ilOOo1IIoI1+I0oloo0IoL0l] end end
local j0OlllI1Loi,jIooj00jol,lO1oioo=iiIOLijIj[3],iiIOLijIj[4],iiIOLijIj[5]
local LOlLj0jo1Ij=iiIOLijIj[7]
local I0l0il=1
local I0LL0L11=0
while true do
local L0Ii0I0=j0OlllI1Loi[I0l0il]
I0l0il=I0l0il+1
local IIoijL,I0oloo0IoL0l,i0i1ioO1,LO0O11I0LO1IiI=L0Ii0I0[1],L0Ii0I0[2],L0Ii0I0[3],L0Ii0I0[4]
local LOOil1jl=looj1j0[IIoijL]
if (LOOil1jl*LOOil1jl+LOOil1jl)%2==1 then LojjjIILLj1=LojjjIILLj1-2 end
if LOOil1jl==23 then
ILlILoIj1OjOl[I0oloo0IoL0l]=((ILlILoIj1OjOl[I0oloo0IoL0l] or 0)+i0i1ioO1)%(LO0O11I0LO1IiI+1)
elseif LOOil1jl==26 then
local jlooliI0iL0
if i0i1ioO1==0 then jlooliI0iL0=I0LL0L11-I0oloo0IoL0l-1 else jlooliI0iL0=i0i1ioO1 end
local lLL00i1=ILlILoIj1OjOl[I0oloo0IoL0l]
for jllojOIIiLil=1,jlooliI0iL0 do lLL00i1[LO0O11I0LO1IiI+jllojOIIiLil]=ILlILoIj1OjOl[I0oloo0IoL0l+jllojOIIiLil] end
elseif LOOil1jl==8 then
ii111l[LiiI1LI0IlIL(jIooj00jol,LOlLj0jo1Ij,i0i1ioO1+1)]=ILlILoIj1OjOl[I0oloo0IoL0l]
elseif LOOil1jl==6 then
ILlILoIj1OjOl[I0oloo0IoL0l]=(ILlILoIj1OjOl[i0i1ioO1]<=ILlILoIj1OjOl[LO0O11I0LO1IiI])
elseif LOOil1jl==29 then
ILlILoIj1OjOl[I0oloo0IoL0l]=ILlILoIj1OjOl[i0i1ioO1]*ILlILoIj1OjOl[LO0O11I0LO1IiI]
elseif LOOil1jl==3 then
ILlILoIj1OjOl[I0oloo0IoL0l]=LiiI1LI0IlIL(jIooj00jol,LOlLj0jo1Ij,i0i1ioO1+1)
elseif LOOil1jl==10 then
ILlILoIj1OjOl[I0oloo0IoL0l]=ILlILoIj1OjOl[i0i1ioO1][ILlILoIj1OjOl[LO0O11I0LO1IiI]]
elseif LOOil1jl==5 then
ILlILoIj1OjOl[I0oloo0IoL0l]=(ILlILoIj1OjOl[i0i1ioO1]-ILlILoIj1OjOl[i0i1ioO1]%ILlILoIj1OjOl[LO0O11I0LO1IiI])/ILlILoIj1OjOl[LO0O11I0LO1IiI]
elseif LOOil1jl==41 then
ILlILoIj1OjOl[I0oloo0IoL0l]=ILlILoIj1OjOl[i0i1ioO1]^ILlILoIj1OjOl[LO0O11I0LO1IiI]
elseif LOOil1jl==33 then
ILlILoIj1OjOl[I0oloo0IoL0l]=ILlILoIj1OjOl[i0i1ioO1]
elseif LOOil1jl==36 then
ILlILoIj1OjOl[I0oloo0IoL0l]=(i0i1ioO1~=0)
elseif LOOil1jl==28 then
ILlILoIj1OjOl[I0oloo0IoL0l]=(ILlILoIj1OjOl[i0i1ioO1]<ILlILoIj1OjOl[LO0O11I0LO1IiI])
elseif LOOil1jl==39 then
ILlILoIj1OjOl[I0oloo0IoL0l]=-ILlILoIj1OjOl[i0i1ioO1]
elseif LOOil1jl==11 then
ILlILoIj1OjOl[I0oloo0IoL0l]=not ILlILoIj1OjOl[i0i1ioO1]
elseif LOOil1jl==38 then
ILlILoIj1OjOl[I0oloo0IoL0l]={ILlILoIj1OjOl[i0i1ioO1]}
elseif LOOil1jl==43 then
ILlILoIj1OjOl[I0oloo0IoL0l]=(ILlILoIj1OjOl[i0i1ioO1]>=ILlILoIj1OjOl[LO0O11I0LO1IiI])
elseif LOOil1jl==13 then
ILlILoIj1OjOl[I0oloo0IoL0l][ILlILoIj1OjOl[i0i1ioO1]]=ILlILoIj1OjOl[LO0O11I0LO1IiI]
elseif LOOil1jl==27 then
ILlILoIj1OjOl[I0oloo0IoL0l]=ILlILoIj1OjOl[i0i1ioO1][1]
elseif LOOil1jl==37 then
if (not not ILlILoIj1OjOl[I0oloo0IoL0l])==(i0i1ioO1~=0) then I0l0il=LO0O11I0LO1IiI+1 end
elseif LOOil1jl==24 then
ILlILoIj1OjOl[I0oloo0IoL0l]=ILlILoIj1OjOl[i0i1ioO1]/ILlILoIj1OjOl[LO0O11I0LO1IiI]
elseif LOOil1jl==22 then
local lLL00i1=ILlILoIj1OjOl[I0oloo0IoL0l]
local jlooliI0iL0
if i0i1ioO1==0 then jlooliI0iL0=I0LL0L11-I0oloo0IoL0l-1 else jlooliI0iL0=i0i1ioO1-1 end
local iL1Liji={}
for jllojOIIiLil=1,jlooliI0iL0 do iL1Liji[jllojOIIiLil]=ILlILoIj1OjOl[I0oloo0IoL0l+jllojOIIiLil] end
local io010ij=LLoIoi(lLL00i1(ILOi11jIjOOo1j(iL1Liji,1,jlooliI0iL0)))
if LO0O11I0LO1IiI==0 then
local iI0IIoooii=io010ij.n
for jllojOIIiLil=1,iI0IIoooii do ILlILoIj1OjOl[I0oloo0IoL0l+jllojOIIiLil-1]=io010ij[jllojOIIiLil] end
I0LL0L11=I0oloo0IoL0l+iI0IIoooii
else
for jllojOIIiLil=1,LO0O11I0LO1IiI-1 do ILlILoIj1OjOl[I0oloo0IoL0l+jllojOIIiLil-1]=io010ij[jllojOIIiLil] end
end
elseif LOOil1jl==1 then
I0l0il=i0i1ioO1+1
elseif LOOil1jl==21 then
ILlILoIj1OjOl[I0oloo0IoL0l]=#ILlILoIj1OjOl[i0i1ioO1]
elseif LOOil1jl==42 then
ILlILoIj1OjOl[I0oloo0IoL0l]=loLij0LIioLljI[i0i1ioO1+1][1]
elseif LOOil1jl==18 then
if i0i1ioO1==0 then
for jllojOIIiLil=1,jl1OLiojI do ILlILoIj1OjOl[I0oloo0IoL0l+jllojOIIiLil-1]=iLjiOi[jllojOIIiLil] end
I0LL0L11=I0oloo0IoL0l+jl1OLiojI
else
for jllojOIIiLil=1,i0i1ioO1-1 do ILlILoIj1OjOl[I0oloo0IoL0l+jllojOIIiLil-1]=iLjiOi[jllojOIIiLil] end
end
elseif LOOil1jl==9 then
ILlILoIj1OjOl[I0oloo0IoL0l]=ILlILoIj1OjOl[I0oloo0IoL0l]+ILlILoIj1OjOl[I0oloo0IoL0l+2]
local lLL00i1=ILlILoIj1OjOl[I0oloo0IoL0l+2]
if (lLL00i1>0 and ILlILoIj1OjOl[I0oloo0IoL0l]<=ILlILoIj1OjOl[I0oloo0IoL0l+1]) or (lLL00i1<=0 and ILlILoIj1OjOl[I0oloo0IoL0l]>=ILlILoIj1OjOl[I0oloo0IoL0l+1]) then ILlILoIj1OjOl[I0oloo0IoL0l+3]=ILlILoIj1OjOl[I0oloo0IoL0l]; I0l0il=i0i1ioO1+1 end
elseif LOOil1jl==35 then
ILlILoIj1OjOl[I0oloo0IoL0l]=ILlILoIj1OjOl[i0i1ioO1]-ILlILoIj1OjOl[LO0O11I0LO1IiI]
elseif LOOil1jl==32 then
local lLL00i1=ILlILoIj1OjOl[I0oloo0IoL0l]
local LLLiiiiIoi=ILlILoIj1OjOl[I0oloo0IoL0l+1]
local jil1OiOLo01O1=ILlILoIj1OjOl[I0oloo0IoL0l+2]
local io010ij=LLoIoi(lLL00i1(LLLiiiiIoi,jil1OiOLo01O1))
local iI0IIoooii=io010ij[1]
if iI0IIoooii~=nil then
ILlILoIj1OjOl[I0oloo0IoL0l+2]=iI0IIoooii
for jllojOIIiLil=1,i0i1ioO1 do ILlILoIj1OjOl[I0oloo0IoL0l+3+jllojOIIiLil-1]=io010ij[jllojOIIiLil] end
I0l0il=LO0O11I0LO1IiI+1
end
elseif LOOil1jl==25 then
ILlILoIj1OjOl[I0oloo0IoL0l]={}
elseif LOOil1jl==30 then
local lLL00i1=lO1oioo[i0i1ioO1+1]
local iL1Liji={}
local io010ij=lLL00i1[6]
for jllojOIIiLil=1,#io010ij do
local iI0IIoooii=io010ij[jllojOIIiLil]
if iI0IIoooii[1]==1 then iL1Liji[jllojOIIiLil]=ILlILoIj1OjOl[iI0IIoooii[2]] else iL1Liji[jllojOIIiLil]=loLij0LIioLljI[iI0IIoooii[2]+1] end
end
ILlILoIj1OjOl[I0oloo0IoL0l]=I11oII(lLL00i1,iL1Liji)
elseif LOOil1jl==12 then
local jlooliI0iL0
if i0i1ioO1==0 then jlooliI0iL0=I0LL0L11-I0oloo0IoL0l else jlooliI0iL0=i0i1ioO1-1 end
local iL1Liji={}
for jllojOIIiLil=1,jlooliI0iL0 do iL1Liji[jllojOIIiLil]=ILlILoIj1OjOl[I0oloo0IoL0l+jllojOIIiLil-1] end
return ILOi11jIjOOo1j(iL1Liji,1,jlooliI0iL0)
elseif LOOil1jl==17 then
ILlILoIj1OjOl[i0i1ioO1][1]=ILlILoIj1OjOl[I0oloo0IoL0l]
elseif LOOil1jl==7 then
ILlILoIj1OjOl[I0oloo0IoL0l]=(ILlILoIj1OjOl[i0i1ioO1]~=ILlILoIj1OjOl[LO0O11I0LO1IiI])
elseif LOOil1jl==16 then
ILlILoIj1OjOl[I0oloo0IoL0l]=ILlILoIj1OjOl[i0i1ioO1]%ILlILoIj1OjOl[LO0O11I0LO1IiI]
elseif LOOil1jl==14 then
ILlILoIj1OjOl[I0oloo0IoL0l]=ii111l[LiiI1LI0IlIL(jIooj00jol,LOlLj0jo1Ij,i0i1ioO1+1)]
elseif LOOil1jl==19 then
loLij0LIioLljI[i0i1ioO1+1][1]=ILlILoIj1OjOl[I0oloo0IoL0l]
elseif LOOil1jl==20 then
ILlILoIj1OjOl[I0oloo0IoL0l]=ILlILoIj1OjOl[i0i1ioO1]..ILlILoIj1OjOl[LO0O11I0LO1IiI]
elseif LOOil1jl==34 then
for jllojOIIiLil=I0oloo0IoL0l,I0oloo0IoL0l+i0i1ioO1 do ILlILoIj1OjOl[jllojOIIiLil]=nil end
elseif LOOil1jl==40 then
ILlILoIj1OjOl[I0oloo0IoL0l]=ILlILoIj1OjOl[i0i1ioO1]+ILlILoIj1OjOl[LO0O11I0LO1IiI]
elseif LOOil1jl==15 then
ILlILoIj1OjOl[I0oloo0IoL0l+1]=ILlILoIj1OjOl[i0i1ioO1]; ILlILoIj1OjOl[I0oloo0IoL0l]=ILlILoIj1OjOl[i0i1ioO1][ILlILoIj1OjOl[LO0O11I0LO1IiI]]
elseif LOOil1jl==31 then
ILlILoIj1OjOl[I0oloo0IoL0l]=ILlILoIj1OjOl[I0oloo0IoL0l]-ILlILoIj1OjOl[I0oloo0IoL0l+2]; I0l0il=i0i1ioO1+1
elseif LOOil1jl==2 then
ILlILoIj1OjOl[I0oloo0IoL0l]=(ILlILoIj1OjOl[i0i1ioO1]==ILlILoIj1OjOl[LO0O11I0LO1IiI])
elseif LOOil1jl==4 then
ILlILoIj1OjOl[I0oloo0IoL0l]=(ILlILoIj1OjOl[i0i1ioO1]>ILlILoIj1OjOl[LO0O11I0LO1IiI])
else l1IiLjo() end
end
return LojjjIILLj1
end
return lOiOLLolj1I1O1(iiIOLijIj,{},LLoIoi(...))
