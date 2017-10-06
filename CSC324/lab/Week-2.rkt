;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "2017-fall-reader.rkt" "csc104")((modname Week-2) (compthink-settings #hash((prefix-types? . #f))))
; CSC324 2017F Lab
; ================

; This lab reviews test-driven development and design, gets you used to the new syntax,
;  does a bit of iteration in a new style, includes a lexically scoped function, and
;  reminds you about the design of recursive functions.

; Implement 'include' so the first check-expect passes, by following the design in the
;  second check-expect:

(check-expect (include "hello" (list "world" "!"))
              (list "hello" "world" "!"))

(check-expect (include "hello" (list "world" "!"))
              (append (list "hello") (list "world" "!")))

(define (include elem a-list)
  (append (list elem) a-list)) ; A stub so the file can run.


; Implement include-hello that adds "hello" to the front of a list:

(check-expect (include-hello (list "there" "friend"))
              (list "hello" "there" "friend"))

(define (include-hello identity)
  (append (list "hello") identity)) ; A stub so the file can run.


; Change the third of the following three check-expects into a full design, by making sure
;  the second expression in it mentions the arguments only as-is, and only relies on the
;  second argument being a list of lists. Use one of the course's new functions, rather
;  than recursing yet.

(check-expect (include-in-all "hello" (list (list "world" "!")
                                            (list "there" "friend")))
              (list (list "hello" "world" "!")
                    (list "hello" "there" "friend")))

(check-expect (include-in-all "hello" (list (list "world" "!")
                                            (list "there" "friend")))
              (local [(define (include-element a-list)
                        (include "hello" a-list))]
                (list (include-element (list "world" "!"))
                      (include-element (list "there" "friend")))))

(check-expect (include-in-all "hello" (list (list "world" "!")
                                            (list "there" "friend")))
              (local [(define (include-element a-list)
                        (include "hello" a-list))]
                (map include-element (list (list "world" "!")
                                           (list "there" "friend")))))

; Now implement include-in-all:
(define (include-in-all elem list-of-lists)
  (local [(define (include-element a-list)
            (include elem a-list))]
    (map include-element list-of-lists))) ; A stub so the file can run.


; Design sub-sequences to take a list, and produce a list of lists where each list in the result
;  is a list of some [possibly none, possibly all] elements from the list, in the same order.
; An example:
(check-expect (sub-sequences (list 1 2 3))
              (list
               (list) (list 3) (list 2) (list 2 3)
               (list 1) (list 1 3) (list 1 2) (list 1 2 3)))

; (steps (sub-sequences (list 3)))
          

; First, change the second expression in this check-expect so the body of the local uses a-list
;  as much as possible:
(check-expect (list
               (list) (list 3) (list 2) (list 2 3)
               (list 1) (list 1 3) (list 1 2) (list 1 2 3))
              (local [(define a-list (list (list) (list 3) (list 2) (list 2 3)))]
                (append a-list (include-in-all 1 a-list))))

; What does a-list represent?
; Write out in words, for a human being, the algorithm suggested by that check-expect:
;
; sub-sequences for (list 2 3)
;

; Recall the function 'first'.
; There is a function 'rest' that, for a non-empty list, produces a list without the first element:
(check-expect (rest (list 3 2 4)) (list 2 4))
; Fix this check-expect to record what the rest of a singleton list produces:
(check-expect (rest (list 4)) (list))

; Change the example check-expect into a full design check-expect for non-empty lists:
(check-expect (sub-sequences (list 1 2 3))
              (list
               (list) (list 3) (list 2) (list 2 3)
               (list 1) (list 1 3) (list 1 2) (list 1 2 3)))

(check-expect (sub-sequences (list 1 2 3))
              (local [(define a-list (sub-sequences (rest (list 1 2 3))))]
                (append a-list (include-in-all (first (list 1 2 3)) a-list))))


; Make a copy of this check-expect, and change it according to the previous check-expect:
(check-expect (sub-sequences (list 3))
              (list (list)
                    (list 3)))

(define sample-list (list 3))
(check-expect (sub-sequences sample-list)
              (local [(define a-list (sub-sequences (rest sample-list)))]
                (cond [(empty? sample-list) (list (list))]
                      [else (append a-list (include-in-all (first sample-list) a-list))])))


; Use that to decide a full design for the empty list:

; There is a predicate 'empty?' that determines whether a list is empty:
(check-expect (empty? (list)) #true)
(check-expect (empty? (list 3 2 4)) #false)
; Implement sub-sequences according to your conditionally full designs:


(define (sub-sequences a-list)
  (local [(define (subseq-list _) (sub-sequences (rest a-list)))]
    (cond [(empty? a-list) (list (list))]
          [else (append (subseq-list "") (include-in-all (first a-list) (subseq-list "")))])))

#| 
(define (sub-sequences a-list)
  (local [(define (rest-subseq new-list)
                        (sub-sequences (rest new-list)))]
                (cond [(empty? a-list) (list (list))]
                      [else (append (rest-subseq a-list)
                                    (include (first a-list) (rest-subseq identity)))]))) ; A stub so the file can run.
|#