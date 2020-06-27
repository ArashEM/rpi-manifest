node('dh-01') {
    stage('Cleanup')
    {
        sh 'rm -rf build/'
        sh 'rm -rf .repo/'
        cleanWs()
    }

    def customImage = docker.image("arash7/yocto-build:v2")
    customImage.inside('-v $WORKSPACE:/workspace -v /home/me/yocto:/cache') {
         
        stage('Download') {
        git 'https://github.com/ArashEM/rpi-manifest.git'
        sh "git submodule update --init"
        sh 'repo init -u . --repo-url https://github.com/ArashEM/git-repo.git'
        sh 'repo sync -v -c --no-clone-bundle -j$(nproc --all)'
        } 
          
        stage('Configuration'){
            sh '/workspace/cookbook/yocto/initialize-bitbake.sh /workspace'
            sh 'cp /workspace/config/bblayers.conf /workspace/build/conf/bblayers.conf'
            sh 'cp /workspace/config/local.conf    /workspace/build/conf/local.conf'
          //sh 'cp /workspace/config/site.conf     /workspace/build/conf/site.conf'
        }
    
        stage('Check') {
            sh '/workspace/cookbook/yocto/run-in-build.sh /workspace bitbake rpi-basic-image --runall=fetch'
        }
    }
}
