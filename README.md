VH Wordlist Maker
Description
VH Wordlist Maker is a bash script designed to automate the generation of custom wordlists depends in target subdomain. It takes a list of subdomains and a wordlist as input and creates a new wordlist.
the final wordlist is like this
```
[wl] + [wl + target.tld] + [subdomains]
```
Usage:
```./vh_wordlist_maker.sh -w [path to your wordlist] -i [path to your subdomain file] [-s] [-h]```
it will convert urls to subdomains if you have list of urls from target.
Options:
-w: Specify the path to your wordlist file.
-i: Specify the path to your subdomain file.
-s: (Optional) Suppress output.
-h: (Optional) Display help menu.
Example:
```./vh_wordlist_maker.sh -w wordlist.txt -i subdomains.txt```
Output
The script generates a new wordlist file named domain-vh-wl.txt, where domain is extracted from the provided subdomain file. It also prints out the path to the generated wordlist file and the command to use it with FFuF.
