pipeline {
  agent any
  environment{
      build = "buils-${JOB_NAME}-${BUILD_NUMBER}"
  }
  parameters {
        choice(
                choices: ['ALL', 'ONLY APP','ONLY STATIC FILE','ONLY CLI'], 
                name: 'deploy_policy'
        )
        choice(
                choices: ['TEST', 'DEV','PRODUCTION','ALL'], 
                name: 'deploy_environment'
        )
        booleanParam(name: 'skip_test', defaultValue: true, description: 'Set to true to skip the test stage')
     
    }

  stages {


     stage('Git Checkout Project') {
            steps {
                script {
                        git branch: 'master',
                        credentialsId: 'github',
                        url: 'https://github.com/rennasalva/laravel-queues'
            }
        }
     }

     
    //  stage('Docker  Build Project') {
    //       steps {
    //        withCredentials([usernamePassword(credentialsId: 'zendphp', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
    //         sh "docker login cr.zend.com -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
    //         sh 'docker-compose -f  $WORKSPACE/docker/docker-compose.yml build'
    //       }
    //     }
    //  }  

    
  stage("ZendPhp Agent") {
            agent {
              docker {
                image 'remote_zend_php_builder'
                args '--entrypoint=""'
                reuseNode true
              }
          }
          
          stages {
              
              stage('ZENDPHP Composer Install') {
                steps {
                  echo 'Running PHP 7.4 tests...'
                  sh 'php -v && php --ri xdebug'
                  echo 'Installing from  Composer'
                  sh 'composer config --no-plugins allow-plugins.kylekatarnls/update-helper true'
                  sh 'cd $WORKSPACE && composer install --no-progress --ignore-platform-reqs'            
                }
              }
              
              stage('ZENDPHP Laravel  setup') {
                steps {
                  echo 'Laravel Setup'
                  sh 'cd $WORKSPACE'            
                  echo 'Running Artisan generate key...'
                  sh 'php artisan key:generate'
                  //sh 'php artisan migrate --force;'
                  sh 'php artisan cache:clear;'
                  sh 'php artisan route:clear'
                  sh 'php artisan key:generate'
                }
              }

              
              stage('ZENDPHP Unit Test') {
                when { expression { params.skip_test != true } }
                steps {
                 echo 'Running PHPUnit tests...'
                  sh 'php $WORKSPACE/vendor/bin/phpunit -c $WORKSPACE/phpunit.xml  --log-junit $WORKSPACE/reports/report-junit.xml  --coverage-clover $WORKSPACE/reports/clover.xml --testdox-html $WORKSPACE/reports/testdox.html'
                  sh 'chmod -R a+w $PWD && chmod -R a+w $WORKSPACE'
                }

                post{
                  success{
                    junit '**/reports/*.xml'
                  }
                }
              }
        
              
              stage('ZENDPHP Checkstyle Report') {
                when { expression { params.skip_test != true } }
                steps {
                  sh 'vendor/bin/phpcs  --report-file=$WORKSPACE/reports/checkstyle.xml --standard=$WORKSPACE/phpcs.xml --extensions=php,inc --ignore=autoload.php --ignore=$WORKSPACE/vendor  $WORKSPACE/app' 
                }
              }
        
              
              stage('ZENDPHP Mess Detection Report') {
                when { expression { params.skip_test != true } }
                steps {
                  sh 'vendor/bin/phpmd $WORKSPACE/app xml  $WORKSPACE/phpmd.xml --reportfile $WORKSPACE/reports/pmd.xml --exclude $WORKSPACE/vendor/ --exclude autoload.php'
                }
              }
          
              
              stage('Report Coverage') {
                when { expression { params.skip_test != true } }
                steps {
                  echo 'GENERATE REPORT CODE COVERAGE.'
                  publishHTML (target: [
                          allowMissing: false,
                          alwaysLinkToLastBuild: false,
                          keepAll: true,
                          reportDir: './coverage',
                          reportFiles: 'index.html',
                          reportName: "Coverage Report"

                  ])
                }
            }

            stage('Zip laravel php application'){
                  steps {
                      sh '''
                        rm -fr app.zip
                      '''
                      zip zipFile: "app.zip", archive: false, dir: "."
                  }                    
            }

            stage('Zip laravel asset application'){
                  steps {
                      sh '''
                        rm -fr asset.zip
                      '''
                      zip zipFile: "asset.zip", archive: false, dir: "$WORKSPACE/public"
                  }                    
            }
        }
    }

  
    stage('Ansible Ping Server') {
          steps {
             sh 'ansible all -i /var/jenkins_home/ansible/hosts --module-name ping'
          }
          
    }
        
    stage('Ansible deploy Application WorkFlow') {
       stages {
          stage('Ansible deploy all Application'){
            when { expression { params.deploy_policy == 'ALL' } }
            steps {
              sh '''
              ansible-playbook ansible/playbooks/deploy.yml -i /var/jenkins_home/ansible/hosts -e "workspace=$WORKSPACE" -e "build=$build"
              '''
            }
          }          
        }
     }
}
