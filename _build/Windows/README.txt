::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                           README.TXT                             ::
::                                                                  ::
:: Last Update: 27/10/2018 17:00 GMT+1                              ::
:: Author(s): Layl - Clément BERTHAUD                               ::
:: COPYRIGHT: Fuel, Layl - Clément BERTHAUD 2018                    ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                     _____   _   _   _____   _      
                    |  ___| | | | | | ____| | |     
                    | |__   | | | | | |__   | |     
                    |  __|  | | | | |  __|  | |     
                    | |     | |_| | | |___  | |___  
                    |_|     \_____/ |_____| |_____| 
                  Frequently Used External Libraries
                        C++ LIBRARY COLLECTION
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  This is the delegate build section in order to build the libraries.
This repository is here to hold and group these libraries
together and delegate the build mechanisms.
  Just run buildall.bat from the regular windows command prompt in
order to build libraries and install them under the _install directory
in this repository root.
  It is strongly advised to turn off any anti-virus or firewall
software while running the setup.bat script.
  Reminder: Qt is not part of extlibs, you have to download the
binaries or build it yourself.

Required:
  - 64bit machine
  - Modern Graphics Card with support for OpenGL3 features
  - At least 8GB RAM
  - Windows 7, 8, 10
  - Recent Video Drivers
  - CMake 3.11.4 or greater
  - Git
  - Visual Studio 15 2017 ( Community Edition is enough )
  - Qt Visual Studio Tools Extension
  - Qt5.10 or greater Installation with prebuilt binaries for msvc2017_64 ( OpenSource license )
  - Download prebuilt numpy wheel for python 3.7 ( numpy-1.15.3+mkl-cp37-cp37m-win_amd64.whl ) from https://www.lfd.uci.edu/~gohlke/pythonlibs/#numpy and put the *.whl file in _dep/ directory.
