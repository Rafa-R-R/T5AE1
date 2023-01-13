#!/bin/bash

operacio=-1



while [ $operacio -ne 0 ]
do

    echo "======= Seleccione operació a realitzar ========"
    echo "1) Nombre de vegades que ha loguejat un usuari"
    echo "2) Nombre de conexions a un mes concret"
    echo "3) Noms de usuaris que s'han loguejat en una data concreta"
    echo "4) Última vegada que s'ha loguejat un usuari concret"
    echo "0) Sortir"
    echo "================================================"

    read -p "Indique operació: " operacio

    if [ $operacio -lt 5 ] && [ $operacio -gt 0 ]
    then

        case $operacio in

            1)
            
                read -p "Indique el nom d'usuari: " nom

                nom="${nom,,}"

                nombre=`grep $nom ./usuarios.txt | wc -l`

                if [ $nombre -gt 0 ]
                then
                    echo "L'usuari $nom, s'ha loguejat $nombre vegades"
                else
                    echo "No s'ha loguejat"
                fi
            ;;

            2)

                read -p "Indique el mes: " mes

                mes="${mes,,}"

                    nombre=`grep ^.*$mes$ ./usuarios.txt | wc -l`

                    if [ $nombre -gt 0 ] 
                    then

                        declare -a array
                        i=0

                        for dia in `grep ^.*$mes$ ./usuarios.txt | awk '{print $2 }'`
                        do

                            array[i]=$dia
                            i=$i+1

                        done

                        echo "Els dies que s'han conectat a $mes son: ${array[*]}"
                        echo "En total: ${#array[*]} vegades"

                    else

                        echo "0 conexions"

                    fi
            ;;

            3)

                dia=-1
                mes=-1
                read -p "Indique el dia: " dia
                read -p "Indique el mes: " mes

                mes="${mes,,}"

                usuaris=`awk '{if($2 == dia && $3 == mes) print $1 }' dia=$dia mes=$mes ./usuarios.txt`

                echo $usuaris

                declare -a loguejats

                i=0

                    for usuari in $usuaris
                    do
                        loguejats[i]=$usuari
                        i=$i+1
                    done

                    totals="${#loguejats[@]}"

                    if [ $totals -gt 0 ]
                    then
                        echo "El/s usuaris loguejats al $dia de $mes son:"
                        echo "${loguejats[*]}"
                    else
                        echo "0 usuaris loguejats el $dia de $mes"
                    fi

            ;;

            4)

                read -p "Indique el nom d'usuari: " nom
                nom="${nom,,}"

                nombre=`grep ^$nom.*$ ./usuarios.txt | wc -l`

                if [ $nombre -eq 1 ]
                then
                    dia=`grep ^$nom.*$ ./usuarios.txt | awk '{ print $2 }'`
                    mes=`grep ^$nom.*$ ./usuarios.txt | awk '{ print $3 }'`
                    echo "L'última conexió de l'usuari $nom va ser el $dia de $mes"

                else

                    for mes in "diciembre" "noviembre" "octubre" "septiembre" "agosto" "julio" "junio" "mayo" "abril" "marzo" "febrero" "enero"
                    do
                        encontrado=false

                        for dia in {31..1} 
                        do

                            nombre=`grep ^$nom.$dia.$mes$ ./usuarios.txt | wc -l`

                            if [ $nombre -gt 0 ] 
                            then

                                encontrado=true
                                echo "L'última conexió de l'usuari $nom va ser el $dia de $mes"
                                break

                            fi

                        done
                        

                        if $encontrado 
                        then

                            break

                        fi

                    done

                fi
            ;;

        esac

            read -p "Pulsa enter per a continuar"

            clear=`clear`
            echo $clear
            
    else 

        if [ $operacio -eq 0 ]
        then

            echo "Sortint.. Fins prompte!"

        else 

            echo "Operació no válida"

        fi

    fi


done
