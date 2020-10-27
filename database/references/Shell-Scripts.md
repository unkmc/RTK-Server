## Troubleshooting

If you edit a shell script in Windows, it will change the line endings in a way that makes the script unusable in Linux. To fix this, simply run the following command in Linux after editing the file:

```
sed -i 's/\r$//' myScript.sh
```
