# Установка
1. ```git clone git@github.com:artyom-causelove/custom-game.git```
2. Необходимо создать символические ссылки в папки Dota 2, чтобы изменения из этого репозитория можно было тестировать в игре:
    * ```mklink /J <путь до папки dota 2 beta/content/custom_game> <путь до папки content из репозитория>```
    * ```mklink /J <путь до папки dota 2 beta/game/custom_game> <путь до папки game из репозитория>```
    > Пример:
    > 
    > ```mklink /J "C:\Users\1\Documents\games\steamapps\common\dota 2 beta\content\dota_addons\custom_game" "C:\Users\1\Desktop\custom_game\content\"```
    > 
    > ```mklink /J "C:\Users\1\Documents\games\steamapps\common\dota 2 beta\game\dota_addons\custom_game" "C:\Users\1\Desktop\custom_game\game\"```
