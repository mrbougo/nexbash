#!/bin/bash

# http://en.wikipedia.org/wiki/Bc_programming_language#Example_code
# http://en.wikipedia.org/wiki/HSL_and_HSV#Conversion_from_HSV_to_RGB
#   h: [0 360[
# s,v: [0 1]

function hsvchain () {
	echo '
		define in(x) {
			auto s
			s = scale
			scale = 0
			x /= 1   /* round x down */
			scale = s
			return (x)
		}
		define rgb(x,y,z){
			return (256*x + 16*y + z)
		}
		define cv(x){
			if(x==0)
				return (rgb(v,t,p))
			if(x==1)
				return (rgb(q,v,p))
			if(x==2)
				return (rgb(p,v,t))
			if(x==3)
				return (rgb(p,q,v))
			if(x==4)
				return (rgb(t,p,v))
			if(x==5)
				return (rgb(v,p,q))
		}'"

		scale=3
		n=$len
		s=$1
		v=in(15*$2)
		p=in(v*(1-s))

		for(j=0; j<n; j++){
			h=j*360/n
			scale=0; i=h/60%6; scale=3
			f=h/60-in(h/60)
			q=in(v*(1-f*s))
			t=in(v*(1-(1-f)*s))
			a=a + $((0x1000))^(n-j-1) * cv(i)
		}

		obase=16
		a
" | bc | tr -d '\\\n'
}

str="$*"
str="$(echo "$str" | sed -r 's/\^[0-9]//g; s/\^x[a-fA-F0-9]{3}//g')"
len=${#str}
codes=$(hsvchain 1 1)
for (( j=$((${#codes}%3)) ; j != 0 ; j--)); do codes="0$codes"; done
ret="say "
for (( j=0 ; j<len ; j++ )); do
	char=${str:$j:1}
	[[ "$char" == " " ]] || ret="${ret}^x${codes:$((j*3)):3}"
	ret="$ret$char"
done
ret="${ret}^7" # Don't know why, some special chars are stripped at the end of a string... This fixes it
echo "$ret"
echo "//$codes"
