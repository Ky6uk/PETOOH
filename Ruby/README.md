### DESCRIPTION

PETOOH interpreter written in [Ruby](http://ruby-lang.org) and [GPL](https://github.com/LavirtheWhiolet/self-bootstrap).

### DEPENDS

[Ruby](http://ruby-lang.org) 1.9.3 or higer.

### BUILD

First, you need to install:
* [Rake](http://docs.seattlerb.org/rake/). Usually it comes with Ruby, but if it isn't then you may install it with the command `gem install rake`.
* [GPL](https://github.com/LavirtheWhiolet/self-bootstrap). Just download ["peg2rb.rb"](https://github.com/LavirtheWhiolet/self-bootstrap/blob/master/peg2rb.rb) into this directory and you are ready.

To (re-)build PETOOH interpreter as a standalone Ruby script you give the command:

    rake petooh.rb

To build a Ruby gem you give the command:
    
    rake gem
    
To build everything in this package you just give the command:
    
    rake

To clean up your directory give the command:

    rake clean

### INSTALL



### USAGE

To run:

    ~$ ruby petooh.rb [options] file

Or, if you have installed the interpreter as a Ruby gem:

    ~$ petooh [options] file

Options:
* `-h` - Get some help.
