#define NUM_FROGS 4 //The number of frogs in this problem, we have two frogs on the left that can only hop right and two frogs on the right that can only hop left.
byte board [5]; 
byte tracker [5];
#define done (\
				((board[0] == 3) || (board[0] == 4)) && \
				((board[1] == 3) || (board[1] == 4)) && \
				(board[2] == 0) 		     && \
				((board[3] == 1) || (board[3] == 2)) && \
				((board[4] == 1) || (board[4] == 2))    \
			  )
proctype printBoard() 
{
	atomic{
	  printf("EMPTY %d, FROG1@%d, FROG2@%d, FROG3@%d, FROG4@%d\n", tracker[0], tracker[1], tracker[2], tracker[3], tracker[4]);
	}
}
proctype move()
{
	int index = 0;
	if 
	:: _pid == 1 || _pid == 2 -> index = _pid - 1; printf ("FROG%d (RIGHT) STARTS AT %d\n", _pid,index+1);
	:: else -> index = _pid; printf("FROG%d (LEFT) STARTS AT %d\n", _pid,index+1);
	fi;
	start:
	atomic {
	if
	:: (_pid == 1 || _pid == 2) ->
			if 
			:: ((index+1)<5) -> 
				if 
				:: (board[index+1]==0) -> printf("FROG%d FROM %d TO %d\n",_pid,index+1, index+2); board[index+1] = _pid;
					tracker[_pid]=index+2; tracker[0]=index+1; board[index] = 0; index = index+1; run printBoard();
				:: else -> skip;
				fi;
			:: else -> skip;
			fi;
			if
			:: ((index+2)<5) ->
				if 
				:: (board[index+2]==0) -> printf("FROG%d FROM %d TO %d\n",_pid,index+1, index+3); board[index+2] = _pid;
					tracker[_pid]=index+3; tracker[0]=index+1; board[index] = 0; index = index+2; run printBoard();
				fi;
			fi;
	:: else -> 
		 	if 
			:: ((index-1)>-1) -> 
				if 
				:: (board[index-1]==0) -> printf("FROG%d FROM %d TO %d\n",_pid,index+1, index); board[index-1] = _pid; 
					tracker[_pid]=index; tracker[0]=index+1; board[index] = 0;index = index-1; run printBoard();
				:: else -> skip;
				fi;
			:: else -> skip;
			fi;
			if
			:: ((index-2)>-1) ->
				if 
				:: (board[index-2]==0) -> printf("FROG%d FROM %d TO %d\n",_pid,index+1, index-1); board[index-2] = _pid; 
					tracker[_pid]=index-1;tracker[0]=index+1; board[index] = 0;index=index-2; run printBoard();
				fi;
			fi;
    fi;
   	}
	assert(!done);
	goto start;
}
init
{
	atomic {
	board[0] = 1;
	board[1] = 2;
	board[2] = 0;
	board[3] = 3;
	board[4] = 4;
	run move();
	run move();
	run move();
	run move();
	tracker[0] = 3;
	tracker[1] = 1;
	tracker[2] = 2;
	tracker[3] = 4;
	tracker[4] = 5;
	printf("EMPTY %d, FROG1@%d, FROG2@%d, FROG3@%d, FROG4@%d\n", tracker[0], tracker[1], tracker[2], tracker[3], tracker[4]);
   }
}
