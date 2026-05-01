##
## EPITECH PROJECT, 2026
## Panoramix
## File description:
## Makefile
##

SRC	=	src/main.c	\
		src/init.c	\
		src/druid.c	\
		src/villager.c

OBJ	=	$(SRC:.c=.o)

NAME	=	panoramix

CC	?= gcc

CFLAGS	= 	-W -Wall -Wextra -pthread -I./include

all:	$(NAME)

$(NAME):	$(OBJ)
	$(CC) -o $(NAME) $(OBJ) $(CFLAGS)

clean:
	rm -f $(OBJ)

fclean: clean
	rm -f $(NAME)

re:	fclean all

tests_run:
	@echo "Building unit tests..."
	$(CC) $(CFLAGS) tests/test_parse_args.c -o tests/unit_tests -lcriterion -pthread
	@echo "Running unit tests..."
	./tests/unit_tests

.PHONY: all clean fclean re tests_run
