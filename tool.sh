#!/bin/bash
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -i|--ignore)
    IGNORE="$2"
    shift # past argument
    ;;
    -f|--file)
    FILEPATH="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift
done
echo IGNORE = "${IGNORE}"
echo FILE = "${FILEPATH}"

IN=$(cat ${FILEPATH} | python -c "import json,sys;obj=json.load(sys.stdin);print obj['Dependencies'];")
IN=${IN//\'}
IN=${IN//u}
IN=${IN//[}
IN=${IN//]}
echo ${IN}
OUT=""
IFS=',' read -ra ADDR <<< "$IN"
for i in "${ADDR[@]}"; do
    pip install ${i}
    if [ $? -ne 0 ];  then
        OUT="${OUT} ${i}"
    fi
done

if [ ! -z "$OUT" ];then
    case $IGNORE in
        Y)
            echo "COMPLETED INSTALLING ALL PACKAGES"
        ;;
        N)
            echo "FOLLOWING DEPENDENCIES FAILED :" $OUT
        ;;
    esac
fi
 
echo DONE
