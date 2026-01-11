

java -jar encoder.jar -i shell.duck -o shell.bin -l resources\br.properties

mkdir shell

python duck2spark.py -i shell.bin -l 1 -f 2000 -o shell\shell.ino