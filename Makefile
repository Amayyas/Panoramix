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

CC = epiclang

CFLAGS	= 	-W -Wall -Wextra -pthread -I./include

COVERAGE_NAME	=	tests/coverage_tests
UNIT_TESTS_NAME	=	unit_tests
TESTS_SRCS	=	$(wildcard tests/test_*.c)
STYLE_REPORT_DIR	=	.reports

all:	$(NAME)

$(NAME):	$(OBJ)
	$(CC) -o $(NAME) $(OBJ) $(CFLAGS)

clean:
	rm -f $(OBJ) $(UNIT_TESTS_NAME)

fclean: clean
	rm -f $(NAME)

re:	fclean all

tests_run:
	@echo "Building unit tests..."
	$(CC) $(CFLAGS) -Dmain=panoramix_main \
		src/main.c src/init.c src/druid.c src/villager.c \
		$(TESTS_SRCS) -o $(UNIT_TESTS_NAME) -lcriterion -pthread
	@echo "Running unit tests..."
	./$(UNIT_TESTS_NAME)

coverage:
	@mkdir -p tests
	@echo "Building coverage binary..."
	$(CC) $(CFLAGS) --coverage -Dmain=panoramix_main \
		src/main.c src/init.c src/druid.c src/villager.c \
		$(TESTS_SRCS) -o $(COVERAGE_NAME) -lcriterion -pthread
	@echo "Running coverage binary..."
	./$(COVERAGE_NAME)
	@echo "Global coverage summary..."
	gcovr --root . --exclude 'tests/.*' \
		--gcov-executable 'gcov' --print-summary
	@echo "Coverage by file..."
	gcovr --root . --exclude 'tests/.*' \
		--gcov-executable 'gcov'
	@rm -f $(COVERAGE_NAME) tests/coverage_tests-*.gcda \
		tests/coverage_tests-*.gcno

functional:
	@echo "Running functional tests..."
	@./scripts/functional_tests.sh

acceptance:
	@echo "Running acceptance tests..."
	@./scripts/acceptance_tests.sh

integration:
	@echo "Running integration tests..."
	@./scripts/integration_tests.sh

regression:
	@echo "Running regression tests..."
	@./scripts/regression_tests.sh

smoke:
	@echo "Running smoke tests..."
	@./scripts/smoke_tests.sh

stress:
	@echo "Running stress tests..."
	@./scripts/stress_tests.sh

style:
	@echo "Running Epitech coding style checker..."
	@$(MAKE) fclean >/dev/null
	@mkdir -p $(STYLE_REPORT_DIR)
	@rm -f $(STYLE_REPORT_DIR)/coding-style-reports.log
	@docker run --rm \
		-v "$(CURDIR)":/mnt/delivery \
		-v "$(CURDIR)/$(STYLE_REPORT_DIR)":/mnt/reports \
		ghcr.io/epitech/coding-style-checker:latest /mnt/delivery /mnt/reports
	@REPORT_FILE="$(CURDIR)/$(STYLE_REPORT_DIR)/coding-style-reports.log"; \
	if [ ! -f "$$REPORT_FILE" ]; then \
		echo "Style checker did not generate $$REPORT_FILE"; \
		exit 1; \
	fi; \
	COUNT=$$(wc -l < "$$REPORT_FILE"); \
	echo "$$COUNT coding style error(s) reported in $$REPORT_FILE"; \
	if [ "$$COUNT" -ne 0 ]; then \
		tail -n 20 "$$REPORT_FILE"; \
		exit 1; \
	fi

.PHONY: all clean fclean re tests_run coverage functional
.PHONY: acceptance integration regression smoke stress style
