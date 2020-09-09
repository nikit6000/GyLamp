# GyLaml

GyLaml - Приложение для управления лампой (актуальная версия) [GyverLamp](https://github.com/AlexGyver/GyverLamp) 

## Как собрать

```
sudo gem install cocoapods
git clone --recursive https://github.com/nikit6000/GyLamp.git && cd GyLamp
pod install
```

## Изменения

* Переписана большая часть приложения
* Использован паттерн VIPER
* Поиск устройств при помощи SSDP
* Новая система управления устройствами (NKDeviceInterpretator)
* Переход к реактивному программированию
* Новый интерфейс
* Добавлена возможность сохранения устройств

## To-Do

* Настройки приложения
* Темная/Светлая темы
* Прикрутить BLE к DeviceInterpretator
* Придумать еще что-нибудь 


## Авторы

* **Тархов Никита** - *Разработка* - [nikit6000](https://github.com/nikit6000)
* **Орлов Александр** - *Разработка* - [anonym0uz](https://github.com/anonym0uz)

## Лиценция

Этот проект лицензируется по лицензии MIT - смотри [LICENSE.md](LICENSE) для подробностей.
