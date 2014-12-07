 + stubbing out the pathing
   + create a data structure that captures a graph with sign-posts
   + an agent whose update code walks them from a starting location to a destination
   + a draw loop that visualizes the above

 - subvert dijkstra's all points shortest path
   + copy/paste and fix the algorithm
   - generate a matrix with a number of pairs of rooms
     - build the matrix given a list of crew member (name, job) pairs
     - make agents for these rooms from the same data
   - build the spaceship from a matrix
   - feed the same matrix to dijkstra's
     - use the resulting paths to populate the sign-posts
   - give the agents starting locations etc from the matrix
