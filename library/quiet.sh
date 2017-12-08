#!/usr/bin/env bash

quiet()
{
  "$@" >/dev/null 2>&1
  return $?
}

