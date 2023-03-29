#!/bin/bash

curr_i=1
curr_j=1
declare -A Grid
player_turn='O'
n=3
moves=0
AI_opponent=false

# Filling grid with a placeholder
setup() {
    for ((i=1;i<=$n;i++)) do
        for ((j=1;j<=$n;j++)) do
            Grid[$i,$j]="-"
        done
    done
}

swap_player() {
	if [[ $player_turn == 'X' ]]; then
		player_turn='O'
	else	
		player_turn='X'
	fi
}

game_state() {
    for ((i=1;i<=$n;i++)) do
        for ((j=1;j<=$n;j++)) do
            echo -n ${Grid[$i,$j]}
        done
    done
}

#Checking only for the right length, updating amount of moves and reading state of the game from string
load() {
	str=$1
	if [ ${#str} -ne $(($n*$n)) ]; then
		echo 'Wrong save code!'
		exit
	fi
	chars=${str//-}
	X_amount=${chars//O}
	O_amount=${chars//X}
	if [ ${#X_amount} -gt ${#O_amount} ]; then
		player_turn='O'
	else
		player_turn='X'
	fi
	moves=${#chars}
    for ((i=1;i<=$n;i++)) do
        for ((j=1;j<=$n;j++)) do
            Grid[$i,$j]=${str::1}
			str=${str:1:$(($n*$n))}
        done

    done
}
#Displaying current state of the game (grid)
show_grid() {
	for ((i=1;i<=$n;i++)) do
            for ((j=1;j<=$n;j++)) do
                echo -ne "${Grid[${i},${j}]}\t"
            done
        echo
    done
}

#Checking for winning conditions
check_win() {
	Grid[$1,$2]=$player_turn
	#rows
	for ((i=1;i<=$n;i++)) do
		if [ ${Grid[$1,$i]} != $player_turn ]; then
			break
		fi
		if [ $i == $n ]; then
			clear
			show_grid
			echo "Player ${player_turn} WON!"
			exit
		fi
    done

	# #columns
	for ((i=1;i<=$n;i++)) do
		if [ ${Grid[$i,$2]} != $player_turn ]; then
			break
		fi
		if [ $i == $n ]; then
			clear
			show_grid
			echo "Player ${player_turn} WON!"
			exit
		fi
    done

	# #diag
	for ((i=1;i<=$n;i++)) do
		if [ ${Grid[$i,$i]} != $player_turn ]; then
			break
		fi
		if [ $i == $n ]; then
			clear
			show_grid
			echo "Player ${player_turn} WON!"
			exit
		fi
    done

	# # #anti-diag
	for ((i=1;i<=$n;i++)) do
		if [ ${Grid[$i,$(($n+1-$i))]} != $player_turn ]; then
			break
		fi
		if [ $i == $n ]; then
			clear
			show_grid
			echo "Player ${player_turn} WON!"
			exit
		fi
    done
}

#Takes random field in grid and checks if it's free
AI_move() {	
	i=$(($RANDOM % $n + 1))
	j=$(($RANDOM % $n + 1))
	while [[ ${Grid[$i,$j]} != '-' ]]; do
		i=$(($RANDOM % $n + 1))
		j=$(($RANDOM % $n + 1))
	done
	Grid[$i,$j]=$player_turn
	moves=$((moves+1))
	check_win $i $j
	swap_player
}

#Function for moving with arrow keys, s key for displaying state of the game, space for making your move
read_key() {
	if read -rsn1 input; then
		if [[ "$input" = "" && ${Grid[$curr_i,$curr_j]} == "-" ]]; then
			Grid[$curr_i,$curr_j]=$player_turn 
			moves=$((moves+1))
			check_win $curr_i $curr_j
			swap_player
		fi
		if [[ "$input" = "s" ]]; then
			echo 'Game state code:'; game_state; echo
			read -rsn1
		fi
		read -rsn1 -t 0.1 input
		if [[ "$input" = "[" ]]; then
			read -rsn1 -t 0.1 input
			case "$input"
			in
				A) if [[ ${curr_i} -gt 1 ]]; then curr_i=$((curr_i-1)); fi ;;
				B) if [[ ${curr_i} -lt $n ]]; then curr_i=$((curr_i+1)); fi ;;
				C) if [[ ${curr_j} -lt $n ]]; then curr_j=$((curr_j+1)); fi ;;
				D) if [[ ${curr_j} -gt 1 ]]; then curr_j=$((curr_j-1)); fi ;;
			esac
		fi
		read -rsn5 -t 0.1
	fi

}

#Main loop
function play() {
    while [[ $moves < $(($n*$n)) ]]; do
        for ((i=1;i<=$n;i++)) do
            for ((j=1;j<=$n;j++)) do
			if [[ ${curr_i} -eq ${i} && ${curr_j} -eq ${j} ]]; then
                echo -ne "${player_turn,,}\t" #Bash 4.0
			else
                echo -ne "${Grid[${i},${j}]}\t"
			fi
        	done
        echo
    	done
		read_key
		if [[ $AI_opponent == true && $player_turn == "X" && $moves < $(($n*$n - 1)) ]]; then
			AI_move
		fi
		clear
    done
	swap_player
	check_win $curr_i $curr_j
	if [[ $moves -gt $(($n*$n - 1)) ]]; then
		echo "DRAW!"
	fi
	show_grid
}

#Loading state of the game, with or without AI
if [[ $1 == '-l' || $1 == '--load' ]]; then
	load $2
	if [[ $3 == '-A' || $3 == '--AI_Player' ]]; then
		AI_opponent=true
	fi
fi

#Starting the game with AI
if [[ $1 == '-A' || $1 == '--AI_Player' ]]; then
	setup
	AI_opponent=true
fi

#Normal 2 player mode
if [[ $# -eq 0 ]]; then
	setup
fi

play
