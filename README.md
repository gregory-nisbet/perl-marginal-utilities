# perl-marginal-utilities
A bad collection of standalone Perl utility functions

The eventual goal is to factor out a subset of these functions into a CPAN-worthy module.

Each of these functions is intended to simplify a repetitive task when writing Perl code such as validating (the presence of) parameters, quoting a Bourne shell fragment, and manipulating lists of lists.

### random bits of philosophy, style, and design goals

Perl is an excellent procedural language if you avoid some of the footguns that make debugging difficult. Outside of `use strict` and `use warnings`, people don't really agree on what they are, however.

#### monomorphism

Functions should be monomorphic i.e. don't dispatch on the type or number of arguments! The only time it's acceptable to use `ref` or the like is for *validating* arguments, which should either result in an exception or returning an error value depending on the function's interface.

Trying to do something reasonable with whatever arguments you are given is a common practice in Perl, it's nice to be able to call a function like

    my_function($foo, $bar, host => '127.0.0.1', port => 5000);
    
or

    my_function($foo, $bar, {host => '127.0.0.1', port => 5000});

The problem is that it isn't immediately obvious how the function is distinguishing those two cases under the hood. It might be counting the number of arguments, or it might be inspecting `$_[2]` to see if it's a simple scalar or a hashref. It might also be checking to see if the *last* argument is a hashref.

Trying to discern the intent of the user by what arguments they handed you can result in stuff like the now deprecated smart match operator `~~`. It has the potential to silently do something legitimate but unexpected in many cases. It's worth noting that the operator was created to surface the behavior of the `given` ... `when` construction which typically matches an unknown value against a value known at compile time, reducing the unpredictability somewhat.
