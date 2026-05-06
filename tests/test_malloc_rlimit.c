/*
** EPITECH PROJECT, 2026
** Panoramix - Criterion tests to trigger malloc failure via rlimit
*/

#include <criterion/criterion.h>
#include "panoramix.h"
#include <sys/resource.h>

Test(malloc_rlimit_suite, main_handles_malloc_failure_rlimit)
{
    struct rlimit rl;
    rl.rlim_cur = 64 * 1024;
    rl.rlim_max = 64 * 1024;
    setrlimit(RLIMIT_AS, &rl);

    char *argv[] = {"./panoramix", "1000000", "1", "1", "1", NULL};
    cr_assert_eq(main(5, argv), 84);
}
