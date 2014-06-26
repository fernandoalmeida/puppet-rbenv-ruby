# == Class: rbenv::dependencies
#
# Packages required for Rbenv/Ruby configuration
#
#
class rbenv::dependencies {
  if !defined(Package['zlib1g'])           { package { 'zlib1g':           ensure => installed } }
  if !defined(Package['zlib1g-dev'])       { package { 'zlib1g-dev':       ensure => installed } }
  if !defined(Package['libssl-dev'])       { package { 'libssl-dev':       ensure => installed } }
  if !defined(Package['libreadline6'])     { package { 'libreadline6':     ensure => installed } }
  if !defined(Package['libreadline6-dev']) { package { 'libreadline6-dev': ensure => installed } }
  if !defined(Package['libyaml-dev'])      { package { 'libyaml-dev':      ensure => installed } }
  if !defined(Package['libxml2-dev'])      { package { 'libxml2-dev':      ensure => installed } }
  if !defined(Package['libxslt-dev'])      { package { 'libxslt-dev':      ensure => installed } }
  if !defined(Package['build-essential'])  { package { 'build-essential':  ensure => installed } }
  if !defined(Package['git-core'])         { package { 'git-core':         ensure => installed } }
  if !defined(Package['curl'])             { package { 'curl':             ensure => installed } }
  if !defined(Package['openssl'])          { package { 'openssl':          ensure => installed } }
}
