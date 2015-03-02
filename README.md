# 체크업 backend VM

현재 장고로 개발되고 있는 CheckUp backend를 로컬 머신에서 가상서버로 운영 가능하게 해주는 스크립트 모음입니다.  
실제 backend repository는 [이곳](https://github.com/Popcorn5/checkup-backend-django)에.

준비물:

 * [Vagrant](https://www.vagrantup.com/)
 * VirtualBox

###Homebrew로 준비물 설치하기:

```bash
$ brew cask install virtualbox
$ brew cask install vagrant
```

###가상 머신 실행시키기:
```bash
$ git clone git@github.com:Popcorn5/checkup-vagrant-settings.git checkup-django
$ cd checkup-django
$ vagrant up
```
이렇게 차례로 하시고 가서 커피 한잔 드시고 오세요. (우분투 설치하고, nginx, python 등 설치하고, 데이터베이스 migration 하고 하면 시간 10분 걸릴꺼에요).  
다 완료되면, 브라우져 켜서 http://localhost:8080/docs 들어가면 backend Swagger 문서 볼 수 있어요.

###가상 머신 업데이트 하기  
가장 최신 버전의 가상머신 실행시킬려면
```bash
$ cd checkup-django
$ vagrant provision
```

###유닛 테스트 실행하기
나중에는 Jenkins 같은 CI를 도입할 생각이긴 하지면 현재는 아래와 같이 들어가시면 되요.
```bash
$ vagrant ssh
$ source /srv/env/bin/activate
$ cd /vagrant/checkup-backend-django/checkup
$ python manage.py test
```
![이거 진짜 재밌는대...](http://1-ps.googleusercontent.com/hk/pEsVsjur9-mHhASR14jwUkOv66/www.catgifpage.com/gifs/266.gif.pagespeed.ce._xw1Ux9SCVPjETYPk28F.gif)

| (• ◡•)| (❍ᴥ❍ʋ)
