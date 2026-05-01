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

CC = clang-20

CFLAGS	= 	-W -Wall -Wextra -pthread -I./include

COVERAGE_NAME	=	tests/coverage_tests
UNIT_TESTS_NAME	=	unit_tests

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
	$(CC) $(CFLAGS) -Dmain=panoramix_main \
		src/main.c src/init.c src/druid.c src/villager.c \
		tests/test_parse_args.c -o $(UNIT_TESTS_NAME) -lcriterion -pthread
	@echo "Running unit tests..."
	./$(UNIT_TESTS_NAME)

coverage:
	@mkdir -p tests
	@echo "Building coverage binary..."
	$(CC) $(CFLAGS) --coverage -Dmain=panoramix_main \
		src/main.c src/init.c src/druid.c src/villager.c \
		tests/test_parse_args.c -o $(COVERAGE_NAME) -lcriterion -pthread
	@echo "Running coverage binary..."
	./$(COVERAGE_NAME)
	@echo "Global coverage summary..."
	gcovr --root . --exclude 'tests/.*' \
		--gcov-executable 'llvm-cov gcov' --print-summary
	@echo "Coverage by file..."
	gcovr --root . --exclude 'tests/.*' \
		--gcov-executable 'llvm-cov gcov'
	@rm -f $(COVERAGE_NAME) tests/coverage_tests-*.gcda \
		tests/coverage_tests-*.gcno

.PHONY: all clean fclean re tests_run coverage
