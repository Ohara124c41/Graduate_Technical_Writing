
import os 
import subprocess 

def alpr():
	os.system("raspistill -o  eu3.jpg")
	#print("image taken")
	proc = subprocess.Popen("/usr/bin/alpr -c eu -n 1  eu3.jpg",shell=True,stdout=subprocess.PIPE,)
	result = proc.communicate()[0]
	result = result.split()
	return result[4]


if __name__ == "__main__": 
	print(alpr())

