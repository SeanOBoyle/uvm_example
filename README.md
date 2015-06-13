# uvm_example
Example SystemVerilog UVM Environment

## Description
A super simple DUT with a UVM verification environment to demonstrate how to construct an extensible UVM environment and directory tree.

DUT has a single host interface called with a simple protocol that I've called "host."

Verification environment has a single agent to drive and monitor the host interface.

Built with UVM 1.1d

### Some Notes on Terminology:
#### Agents vs UVCs
Agents drive DUT specific Protocol.

UVCs drive (and monitor) company (or industry) wide protocols. UVCs often live in a repository that is independent of the DUT project repository.

#### Tests vs Sequences
Tests instance and configure the environment.

Test sequences drive the ordered set of transactions to the DUT.

Tests are not reusable by a higher level (chip, SoC, ..) environment, where virtual sequences are reusable.

This example's test_base instances the test sequence through a plusarg "UVM_VSEQ_TESTNAME."


## Directory Structure
* .dvt - config files for AMIQ DVT tool
* src - rtl source -- the DUT
* verif - verification code and scripts
  * sim - verification code
    * env - verification environment; specific to the DUT
      * agents - all agents that are DUT specific (agents that are general are called 'UVCs' and live in the lib directory)
        * host - the host interface agent
          * sequence_lib - the host interface sequence library
          * src - the host agent package: component and child components; config object; item object; interface
      * src - the environment package: component, config object, virtual sequencer
      * sequence_lib - the environment virtual sequence library
    * tb - testbenches -- all block and sub-block benches
      * rtl - the RTL bench for the DUT
    * tests - dut environment tests
    * lib - general library verification code
      * uvm
        * addons - company wide add-ons to UVM
        * extensions - company wide extensions of UVM source
        * release - the UVM library
      * uvcs - cross project "agents" called UVCs
  * tool_setup - everything required to build and run the environment
    * files - file lists
    * run - scripts to run, view waves, etc.
 
NOTE: at each level we create a 'src' folder in case there are any other folders (like 'doc') that would also reside in that folder

