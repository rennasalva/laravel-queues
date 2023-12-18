pipeline {
  agent any
  environment{
      build = "buils-${JOB_NAME}-${BUILD_NUMBER}"
  }
  stages {


     stage('Git Checkout Project') {
            steps {
                script {
                        git branch: 'main',
                        credentialsId: 'github',
                        url: 'https://github.com/rennasalva/unit-test-examples'
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
                  sh 'cd $WORKSPACE/app && composer install --no-progress --ignore-platform-reqs'            
                  echo 'Running PHPUnit tests...'
                  sh 'php $WORKSPACE/app/vendor/bin/phpunit -c $WORKSPACE/app/phpunit.xml  --log-junit $WORKSPACE/app/reports/report-junit.xml  --coverage-clover $WORKSPACE/app/reports/clover.xml --testdox-html $WORKSPACE/app/reports/testdox.html'
                  sh 'chmod -R a+w $PWD && chmod -R a+w $WORKSPACE'
                }

                post{
                  success{
                    junit '**/reports/*.xml'
                  }
                }
              }
        
              stage('ZENDPHP Checkstyle Report') {
                steps {
                  sh 'app/vendor/bin/phpcs  --report-file=$WORKSPACE/app/reports/checkstyle.xml --standard=$WORKSPACE/app/phpcs.xml --extensions=php,inc --ignore=autoload.php --ignore=$WORKSPACE/app/vendor/  $WORKSPACE/app/src' 
                }
                
              }
        
              stage('ZENDPHP Mess Detection Report') {
                steps {
                  sh 'app/vendor/bin/phpmd $WORKSPACE/app/src xml  $WORKSPACE/app/phpmd.xml --reportfile $WORKSPACE/app/reports/pmd.xml --exclude $WORKSPACE/app/vendor/ --exclude autoload.php'
                }
              }
          
              stage('Report Coverage') {
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

               stage('Zip whole workspace'){
                  steps {
                      sh '''
                        rm -fr app.zip
                      '''
                      zip zipFile: "app.zip", archive: false, dir: "./app"
                  }                    
            }
        }
    }

  
    stage('Ansible Ping Server') {
          steps {
             sh 'ansible all -i /var/jenkins_home/ansible/hosts --module-name ping'
          }
          
    }
        
    stage('Ansible deploy Application') {
          steps {
             sh '''
             ansible-playbook ansible/playbooks/deploy.yml -i /var/jenkins_home/ansible/hosts -e "workspace=/var/jenkins_home/workspace/pipeline-unit-test-repo" -e "build=$build"
             '''
          }
          
        }
     }
}
