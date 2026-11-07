
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Flutter build çıktılarının konumu
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()

rootProject.layout.buildDirectory.value(newBuildDir)

// Alt projelerin build dizinlerini ayarla
subprojects {
    val newSubprojectBuildDir: Directory =
        newBuildDir.dir(project.name)

    project.layout.buildDirectory.value(newSubprojectBuildDir)
}


subprojects {
    configurations.configureEach {
        resolutionStrategy.force(
            "androidx.core:core:1.16.0",
            "androidx.core:core-ktx:1.16.0"
        )
    }
}

// App modülünün önce değerlendirilmesini sağla
subprojects {
    project.evaluationDependsOn(":app")
}

// Clean görevi
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
