#! /bin/bash
getDataByID() {
	read -p "Please enter 'movie id'(1~1682):" id
	echo ""
	awk -v n=$id 'n==NR {print $0}' $1
}
getDataByGenre() {
	read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n):" ans
	if [ "$ans"="y" ]
	then
		echo
		awk -F"|" -v cnt=0 '$7==1 && cnt<10 {printf("%d %s\n", $1, $2); cnt++}' $1
	fi
}
getAverageByID() {	
	read -p "Please enter 'movie id'(1~1682):" id
	awk '
	BEGIN {
		cnt=0
		total=0
	}
	$2=='"$id"' {
		cnt=cnt+1
		total=total+$3
	}
	END {
	printf("\naverage rating of %d: %.5f\n", '"$id"', total/cnt) 
	}
	' $1
}
deleteURL() {
	read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n):" ans
	if [ "$ans" = "y" ]
	then
		echo ""
		sed -E 's/http[^\|]*//' $1 | sed -n '1,10p'
	fi
}
getUserData() {
	read -p "Do you want to get the data about users from 'u.users'?(y/n):" ans
	if [ "$ans" = "y" ]
	then
		echo ""
		sed -E 's/M[^\|]*/male/' $1 | sed -E 's/F[^\|]*/female/'| sed -E 's/([0-9]+)\|([0-9]+)\|(.*)\|(.*)\|(.*)/user \1 is \1 years old \3 \4/'| head -n 10
	fi
}
changeDateFormat() {
	read -p "Do you want to Modify the format of 'release date' in 'u.item'?(y/n):" ans
	if [ "$ans" = "y" ]
	then
		echo ""
		sed -E -e 's/Jan/01/' -e 's/Feb/02/' -e 's/Mar/03/' -e 's/Apr/04/' -e 's/May/05/' -e 's/Jun/06/' -e 's/Jul/07/' -e 's/Aug/08/' -e 's/Sep/09/' -e 's/Oct/10/' -e 's/Nov/11/' -e 's/Dec/12/' $1 | sed -E 's/([0-9]+)\|(.*)\|([0-9]+)\-([0-9]+)\-([0-9]+)\|(.*)/\1\|\2\|\5\4\3\|\6/' | sed -n '1673,1682p'
	fi
}
getRatedMoviesByUser() {
	read -p "Please Enter the 'user id'(1~943):" id
	echo
	idData=$(awk -v id="$id" 'id==$1 {print $2}' $2 | sort -k2 | sort -n)
	echo $idData | sed -E 's/\s/\|/g'
	echo
	arr=($idData)
	for cnt in $(seq 0 9)
	do	
		movID=${arr[$cnt]}
		awk -F"|" -v movID="$movID" 'movID==$1 {printf("%d|%s\n", $1, $2)}' $1
	done
}
getAverageRatingMovies() {
	read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n):" ans
	if [ "$ans" = "y" ]
	then
		users=$(awk -F"|" '$2 >= 20 && $2 <= 29 && $4=="programmer" {print 1} $2 > 29 || $2 < 20 || $4 != "programmer" {print 0}' $2)
		awk -v users="${users[*]}" 'BEGIN{split(users, ids, " ")} ids[$1]==1  {total[$2] += $3; cnt[$2]++} END { for (i in total) print i, total[i]/cnt[i] }' $1
	fi
}
echo --------------------------
echo User Name: Lee JaeWook
echo Student Number: 12223781
echo "[ Menu ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'
2. Get the data of 'action' genre movies from 'u.item'
3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.item'
4. Delete the 'IMDb URL' from 'u.item'
5. Get the data about users from 'u.user'
6. Modify the format of 'release date' in 'u.item'
7. Get the data of movies rated by a specific 'user id' from 'u.data'
8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'
9.Exit"
echo --------------------------
while true
do
read -p "Enter your Choice [ 1-9 ] " task
echo ""
case $task in
	1)
		getDataByID $1
		;;
	2)
		getDataByGenre $1
		;;
	3)
		getAverageByID $2
		;;
	4)
		deleteURL $1
		;;
	5)
		getUserData $3
		;;
	6)
		changeDateFormat $1
		;;
	7)
		getRatedMoviesByUser $1 $2
		;;
	8)
		getAverageRatingMovies $2 $3
		;;
	9)
		echo Bye!
		exit 0
		;;
esac
	echo ""
done
