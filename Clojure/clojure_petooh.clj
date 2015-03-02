(defn parse-input
  []
  (vec (map keyword
         (flatten
           (map #(re-seq #"Ko|kO|Kudah|kudah|Kukarek|Kud|kud" %) (line-seq (java.io.BufferedReader. *in*)))))))

(defn make-data
  [commands current-command input]
  (if (or (= current-command (count input)) (= (input current-command) :kud ))
    {:c commands :cc current-command}
    (if (= (input current-command) :Kud )
      (let [{:keys [cc c]} (make-data [] (inc current-command) input)]
        (recur (conj commands c) (inc cc) input))
      (recur (conj commands (input current-command)) (inc current-command) input))))

(defmulti _interpret #(class %2))

(defmethod _interpret clojure.lang.Keyword
  [{:keys [cells current-cell] :as cells-state} command]
  (condp = command
    :Ko {:cells (update-in cells [current-cell] inc) :current-cell current-cell}
    :kO {:cells (update-in cells [current-cell] dec) :current-cell current-cell}
    :Kudah {:cells (if (= (inc current-cell) (count cells)) (conj cells 0) cells) :current-cell (inc current-cell)}
    :kudah {:cells cells :current-cell (dec current-cell)}
    :Kukarek (do
               (print (char (cells current-cell)))
               cells-state)))

(defn interpret
  [cells-state command]
  (reduce _interpret (cons cells-state command)))

(defmethod _interpret clojure.lang.IPersistentVector
  [{:keys [cells current-cell] :as cells-state} command]
  (if (zero? (cells current-cell))
    cells-state
    (recur (interpret cells-state command) command)))

(interpret {:cells [0] :current-cell 0} (:c (make-data [] 0 (parse-input))))
