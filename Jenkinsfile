node('docker-host-01') {
    stage('Cleanup')
    {
      //sh 'rm -rf build'
      //sh 'rm -rf .repo'
      cleanWs()

    }
    stage('Download') {
	checkout scm
        sh "git submodule update --init"
        sh 'repo init -u . --repo-url https://github.com/ArashEM/git-repo.git'
        sh 'repo sync -v -c --no-clone-bundle -j$(nproc --all)'
    }

    def customImage = docker.image("arash7/yocto-build:v1")
    customImage.inside('-v $WORKSPACE:/workspace -v $HOME/yocto-cache:/cache') {
         
        stage('Configuration'){
            sh '/workspace/cookbook/yocto/initialize-bitbake.sh /workspace'
            sh 'cp /workspace/config/bblayers.conf /workspace/build/conf/bblayers.conf'
            sh 'cp /workspace/config/local.conf    /workspace/build/conf/local.conf'
          //sh 'cp /workspace/config/site.conf     /workspace/build/conf/site.conf'
        }
    
        stage('Build') {
            sh '/workspace/cookbook/yocto/run-in-build.sh /workspace bitbake core-image-base'
            archiveArtifacts 'build/tmp/deploy/images/raspberrypi/*.rpi-sdimg'
        }

    }
}
