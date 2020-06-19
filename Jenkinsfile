node('docker-host-01') {
    stage('Cleanup')
    {
        sh 'rm -rf build/'
    }
    stage('Download') {
        git 'https://github.com/ArashEM/rpi-manifest.git'
        sh "git submodule update --init"
        sh 'repo init -u .'
        sh 'repo sync -v -c --no-clone-bundle -j$(nproc --all)'
    }

    def customImage = docker.image("pelux/pelux-yocto:yoctouser")
    customImage.inside('-v $WORKSPACE:/workspace') {
         
        stage('Configuration'){
            sh '/workspace/cookbook/yocto/initialize-bitbake.sh /workspace'
            sh 'cp /workspace/config/bblayers.conf /workspace/build/conf/bblayers.conf'
            sh 'cp /workspace/config/local.conf    /workspace/build/conf/local.conf'
            sh 'cp /workspace/config/site.conf     /workspace/build/conf/site.conf'
        }
    
        stage('Check') {
            sh '/workspace/cookbook/yocto/run-in-build.sh /workspace bitbake rpi-basic-image --runall=fetch'
        }
    }
}
