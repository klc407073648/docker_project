#!/bin/bash
source ./common.sh

function MAIN() 
{
  logError "${0}:clean_after_build begin"
  cleanRunContainer
  logError "${0}:clean_after_build end"
}

MAIN

checkMainResult