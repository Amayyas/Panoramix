/*
** EPITECH PROJECT, 2026
** Panoramix - Criterion tests
*/

#include <criterion/criterion.h>
#include "panoramix.h"

int main(int ac, char **av);

Test(main_suite, valid_simulation_completes)
{
    char *argv[] = {"./panoramix", "2", "1", "1", "1", NULL};

    cr_assert_eq(main(5, argv), 0);
}

Test(main_suite, invalid_args_return_84)
{
    char *argv[] = {"./panoramix", "2", NULL};
    cr_assert_eq(main(2, argv), 84);
}