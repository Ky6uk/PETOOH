### USAGE
    ~$ mvn dependency:get -Dartifact=org.clojure:clojure:1.6.0 -DremoteRepositories=central::default::http://repo1.maven.apache.org/maven2
    ~$ java -cp ~/.m2/repository/org/clojure/clojure/1.6.0/clojure-1.6.0.jar clojure.main clojure_petooh.clj < ../test.koko
