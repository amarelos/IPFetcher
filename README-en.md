# IPFetcher

IPFetcher is a practical and efficient tool designed to validate the response of IP addresses directly in an application.

To use it, you need to search for a specific range of target IPs and compile a list of these addresses. The goal is to check if the IPs have active web services on ports 80 or 443. Additionally, if an application is found, the tool will allow you to test access through a specific path.

## Usage

Simple execution:<br>
`./IPFetcher.sh -iL ip.txt`

Forced execution via HTTPS:<br>
`./IPFetcher.sh -iL ip.txt -iS`

Execution specifying a unique application path:<br>
`./IPFetcher.sh -iL ip.txt -iS -P "/WebSrv/admin/"`

Forced execution via HTTPS, filtering only responses with the mentioned status codes:<br>
`./IPFetcher.sh -iL ip.txt -iS -sc 200,302,401`

Forced execution via HTTPS, setting a maximum timeout:<br>
`./IPFetcher.sh -iL ip.txt -iS -t 10`

Forced execution via HTTPS, specifying ports:<br>
`./IPFetcher.sh -iL ip.txt -iS --ports 443,8080,8088`

```
Options:
Usage: ./IPFetcher.sh -iL <file_with_ips> [-iS] [-iV] [-P <path>] [-U <url>] [-t <timeout>] [-v|--verbose] [-sc <status_codes>] [--ports <ports>] [-iP]
-iL <file_with_ips> : Text file containing the IPs.
-iS                 : Makes HTTPS requests.
-iV                 : Replaces the hostname in the URL with the IP (must be used with -U).
-P <path>          : The path to be used in requests, enclosed in quotes.
-U <url>           : A complete URL to make requests (e.g., https://lab.net/admin).
-sc <status_codes> : Filters responses to show only the specified statuses (e.g., 200,404).
-t <timeout>       : Maximum time in seconds for the request. Default time is 30 seconds.
-v|--verbose        : Enables detailed information display.
-h|--help          : Displays this help message.
--ports <ports>    : One or more comma-separated ports to test (e.g., 80,443,8080).
-iP                 : Uses default ports (80, 443, 8080, 8888, 8443) for the IPs when not specified with --ports.
```
